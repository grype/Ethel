# Methodologies

Ethel tries not to impose too much on how you design your client and endpoints. This is generally a good thing, but it also means that there are many ways of going about composing your client. A few methods proved to be helpful over time. This documents outlines a few of those methods...

* [Encapsulation](#Encapsulation)
* [Defaults](#Defaults)
* [Materializing Data](#Materializing-Data)

## Encapsulation

Keep your endpoints simple, and avoid mixed responsibilities. It's a lot easier to deal with a few smaller endpoints than one massive one. To break down massive endpoints, create a parent endpoint that proxies for the specialized endpoints. For example, we could split the following into separate endpoints:

```smalltalk
Object subclass: #SomeEndpoint
    uses: TWSEndpoint
    slots: { #query. #limit. #id }

SomeEndpoint class>>#endpointPath
    ^ Path / #somewhere

SomeEndpoint>>#search
    <get>
    ^ self execute

SomeEndpoint>>#info
    <get>
    ^ self execute
```

You may be hitting the same path on the web service, but the endpoint seems to capture multiple responsibilities. It becomes less clear about how to use the class, which properties need to be provided for a particular executing method, etc.

One way to deal with this would be to capture those parameters in the executing method, like:

```smalltalk
SomeEndpoint>>#search: aQuery
    <get>
    ^ self execute: [ :http | http request queryAt: #query put: aQuery ]
```

Which is a fine approach when you have one or two parameters. In other cases, it's best to create a separate endpoint:

```smalltalk
Object subclass: #SomeEndpoint
    uses: TWSEndpoint

SomeEndpoint class>>#endpointPath
    ^ Path / #somewhere


Object subclass: #SearchEndpoint
    uses: TWSEndpoint
    slots: { #query. #limit }

SearchEndpoint class>>#endpointPath
    ^ ParentEndpoint endpointPath

SearchEndpoint>>#configureOn: http
    http request headerAt: #query put: query.
    limit ifNotNil: [ :val | http request headerAt: #limit put: limit ].

SearchEndpoint>>#execute
    <get>
    ^ wsClient execute: self


SomeEndpoint>>#search
    ^ self / SearchEndpoint
```

Now,

```smalltalk
client somewhere search query: 'something'; limit: 100; execute.
```

Or use a block for configuring the search endpoint:

```smalltalk
SomeEndpoint>>#search: aBlock
    | endpoint |
    endpoint := self / SearchEndpoint.
    aBlock cull: endpoint.
    ^ endpoint execute
```

And,

```smalltalk
client somewhere search: [ :endpoint | endpoint query: 'something'; limit: 100 ].
```

By encapsulating the search functionality in its own endpoint makes it more clear and concise, easier to maintain and, in many actual cases, reveals something about the web service...

## Defaults

In many cases, the web client bears some kind of identification and authorization information. In some cases, web services provide multiple environments (development, staging, production, etc). This information can easily be captured in class side methods of your `WSClient` subclass:

```smalltalk
WSClient subclass: MyClient
    slots: { }
    classVariables: { #DevelopmentUrl. #ProductionUrl }

MyClient class>>development
    ^ self withUrl: DevelopmentUrl

MyClient class>>production
    ^ self withUrl: ProductionUrl
```

This comes in handy when you find yourself in a Playground. Putting authorization info into instance creators is probably not a good idea. Putting it into Settings, on the other hand, has a few advantages: it makes it easier to configure - both, during development and production; and makes it possible to have a 'default' client.

```smalltalk
WSClient subclass: MyClient
    slots: { }
    classVariables: { #DevelopmentUrl. #ProductionUrl. #DefaultDomain. #DefaultSecret }

MyClient class>>settingsOn: aBuilder
    <systemsettings>
    (aBuilder group: #MyClient)
        label: 'MyClient';
        description: 'MyClient Settings';
        parent: #tools;
        with: [ (aBuilder pickOne: #defaultDomain)
            target: self;
            label: 'Domain';
            description: 'Default Domain';
            domainValues: { ('Development' -> #development). ('Production' -> #production) }.
            
        (aBuilder setting: #defaultSecret)
            target: self;
            label: 'Secret';
            description: 'Default secret'
        ]

MyClient class>>#default
    | client |
    self assert: DefaultDomain isNotNil description: 'Please set default domain in Settings'.
    self assert: DefaultSecret isNotNil description: 'Please set secret token in Settings'.
    client := self perform: DefaultDomain.
    client secret: DefaultSecret.
    ^ client
```

After providing accessors for the defaults:

```smalltalk
client := MyClient default.
elements := client elements.
```

Let's assume that `elements` now contains instances of:

```smalltalk
Object subclass: MyElement
    slots: { #compoundId }

MyElement>>#compound
    ^ MyClient default compounds at: #compoundId
```

Having a default client simplifies handling of computed properties:

```smalltalk
compounds := elements collect: #compound.
```

## Materializing data

Materializing data from the web service into concrete types can take place in **executing methods**:

```smalltalk
MyEndpoint>>elements
    <get>
    ^ MyType fromJson: self execute
```

Another way to do this could be:

```smalltalk
MyEndpoint>>elements
    <responseListOfType: #MyElement>
    <get>
    ^ self execute
```

Capturing return type in a pragma can be helpful when analyzing endpoints. To make this happen:

```smalltalk
Trait named: #TMyEndpoint
    uses: TWSEndpoint @ {#defaultPrepareForExecutingOn:->#prepareForExecutingOn:}

TMyEndpoint>>#prepareForExecutingOn: http
    self defaultPrepareForExecutingOn: http.
    self configureContentReaderOn: http

TMyEndpoint>>configureContentReaderOn: http
    http 
        contentReader: [ :json |
            | mapper |
            mapper := NeoJSONReader on: json readStream.

            self responseListOfType ifNotNil: [ :responseType |
                mapper nextAs: responseType ] ]

TMyEndpoint>>#responseListOfType
    ^ self executionContextPragmaAt: #responseListOfType

TMyEndpoint>>#executionContextPragmaAt: aSelector
    | ctx |
    ctx := self executingContext.
    ^ ctx method pragmas
        detect: [ :each | each selector = aSelector ]
        ifFound: [ :pragma |
            pragma arguments anyOne 
                ifNil: [ nil ]
                ifNotNil: [ :cls | Smalltalk at: cls ] ]
        ifNone: [ nil ]
```

It makes sense to create a new trait for this, overriding/swizzling #prepareForExecution: method. In our version of this method, we configure the content reader to, using NeoJSON, read in the response as the type specified in the executing method's <responseListOfType> pragma. To get that value, we use the method's `#executingContext`, as evident in `TMyEndpoint>>#executionContextPragmaAt:`.
