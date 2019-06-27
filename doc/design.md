# Design

## Contents

- [The client](#the-client)
- [The endpoint](#the-endpoint)
- [Request execution](#request-execution)
- [Execution Context](#execution-context)
- [Enumeration](#enumeration)


There are two basic building blocks in Ethel - a client and an endpoint. A client, implemented by `WSClient`, has one essential job - to create and execute endpoints. An endpoint, implemented by `TWSEndpoint` trait, is used to encapsulate one or more logical structures of an API. You interact with the client by deriving an endpoint of interest and executing it.

When a client executes an endpoint, it first creates and configures an http transport, `ZnClient`, and then passes it to the endpoint for further configuration, before finally executing the resulting http request. This means that a client typically manages data that is common to all endpoints. While an endpoint  manages data that is specific to a particular logical construct - i.e. parameters for querying or creating a resource.

Let’s take a look at each building block in more detail...

## The client

`WSClient` manages only two bits of data: the base URL, via `#baseUrl`, and a block for configuring http transport, via `#httpConfiguration:`. 

The base URL is used to derive the full request URL when executing an endpoint, with the endpoint providing a path relative to the base URL. So, in a sense - the base URL is a common root to all the endpoints. When subclassing, however, you could take care of the base URL à la specialized instance creators:

```smalltalk
WSClient subclass: #AcmeClient
    slots: { }
    classVariables: { SandboxURL ProductionURL }
    package: 'Acme'

WSClient class>>#initialize
    ProductionURL := 'http://example.com/api'.
    SandboxURL := 'http://sandbox.example.com/api'

WSClient class>>sandbox
    ^ self withUrl: SandboxURL

WSClient class>>production
    ^ self withUrl: ProductionURL 
```

The http configuration block is optional and acts as a hook for configuring the request. It is mostly useful when scripting, or when creating instances with specialized configurations. You can see an example in `WSClient class>>#jsonWithUrl:`, where this block is used to configure `ZnClient` with a `NeoJSON` content reader and writer. 

When subclassing, it is better to use `#configureOn:` method, rather than use the pluggable http configuration block. This is where it would make sense to set any kind authentication headers, user-agent strings, or anything that’s common to all endpoints. For configurations that are specific to endpoints - it’s best to use the endpoint's `#configureOn:`.

## The Endpoint

The endpoint behavior is implemented in `TWSEndpoint` trait. So any object could be an endpoint.

```smalltalk
Object subclass: #AcmeThingsEndpoint
    uses: TWSEndpoint
    slots: { }
    classVariables: { }
    package: 'Acme'
```

Endpoint class must define `#endpointPath`:

```smalltalk
AcmeThingsEndpoint class>>#endpointPath
    ^ Path / #things
```

Endpoints are instantiated with a client object, and capture it via `#wsClient` ivar.

```smalltalk
client := AcmeClient sandbox.
client / AcmeThingsEndpoint.
client / #things.
AcmeThingsEndpoint on: client.
```

Customarily, the client, as well as endpoints, would provide methods for deriving other endpoints, thus establishing logical relationships between them.

```smalltalk
AcmeClient>>things
    ^ self / AcmeThingsEndpoint
```

Endpoints should encapsulate some logical structure represented by the web service. It is up to you to define what these structure are and how you’d like to interface with them. But for a simple example, let’s say a search endpoint would be defined as follows:

```smalltalk
Object subclass: #AcmeSearchEndpoint
    uses: TWSEndpoint
    slots: { #query }
    package: 'Acme'

AcmeSearchEndpoint class>>endpointPath
    "/things/search"
    ^ AcmeThingsEndpoint endpointPath / #search

AcmeSearchEndpoint>>search: aString
    <get>
    query := aString.
    ^ self execute

AcmeSearchEndpoint>>configureOn: http
    http request queryAt: #query put: query
```

Notice the separation b/w data management and request execution. Here, we use an ivar to store the query, but actually configure the request with the query parameter in `#configureOn:`. To execute an endpoint - simply call `#execute`, as seen in `AcmeSearchEndpoint>>#search`. Let's call this kind of method an **executing method**, meaning - it begins request execution.

Let’s look at how requests are executed...

### Request execution

Requests are actually executed by the client object, but the process usually starts with the endpoint, as in:

```smalltalk
(client / AcmeSearchEndpoint) search: 'meaning of life'
```

Let's look at the implementing method:

```smalltalk
AcmeSearchEndpoint>>search: aString
    <get>
    query := aString.
    ^ self execute
```

You’ll notice two things. First, is that it returns the result of `self execute`, which simply calls: `wsClient execute: self`. Second, is the `<get>` pragma. It is this pragma that is used to designate the **executing method**. The value of this pragma is also used to configure the http request method, in this case GET. List of the recognized HTTP methods is defined in `WSClient class>>supportedHttpMethods`, and can be changed, affecting identification of **executing methods**.

Another way to execute request is via `TWSEndpoint>>#execute:` method:

```smalltalk
AcmeSearchEndpoint>>search: aString
    <get>
    ^ self execute: [ :http | http request queryAt: #query put: aString ]
```

This way we can skip the instance variable altogether. The argument block is the last thing that gets to configure the http transport before its request is executed, and therefore happens after callign `#configureOn:`. Notice, we still designate the method with the `<get>` pragma, even though we could easily override that inside the execution block.

Now, once the request is configured, it is validated (`#validateRequest:`), executed (by calling `ZnClient>>#execute`), and the response is validated (`#validateResponse:`) before the result is returned. Use those validation methods to handle misconfigured requests and erroneous responses.

### Execution Context

During the execution phase, the **executing method** sets the execution context. This context, as previously seen, contains both the HTTP method and the final URL for the request. The former is handled via pragmas, like `<get>`, `<post>`, etc. The latter, however, requires a bit of explanation.

Let's try to simplify our interface a bit by getting rid of the `AcmeSearchEndpoint` altogether, replacing it with:

```smalltalk
AcmeThingsEndpoint>>search: aString
    <path: 'search'>
    <get>
    ^ self execute: [ :http | http queryAt: #query put: aString ].
```

During execution, the value of the `<path>` pragma, if present, will be resolved against the class-side `#endpointPath`. Without the `<path>` pragma - the instance-side `#endpointPath` is used, which, by default, returns the class-side value. This path resolution happens between the client's and the endpoint's `#configureOn:` calls. 

It should be clear that the newly added method will result in a GET request to */things/search*, resolved by appending relative path from `<path>` to `AcmeThingsEndpoint class>>#endpointPath`. Had we defined an absolute path, e.g. `<path: '/search'>`, the resulting URL would have been */search*.

Paths can also use format strings. For example:

```smalltalk
AcmeThingsEndpoint>>at: aThingId
    <path: '{aThingId}’>
    <get>
    ^ self execute.

client things at: ‘idOfSomeThing'.
```

In this case, calling `#at:` will result in a GET /things/idOfSomeThing. The string format is identical to `String>>format:`, and the variables are sourced from the execution context of the **executing method**. And since path resolution happens at execution time, both `#endpointPath` methods and the `<path:>` pragma can make use of string formatting.

It is worth noting that the use of pragmas is mainly for organizational purpose. We could easily provide complete request configuration inside an execution block passed to `#execute:`. So, to put things into perspective: mark **executing methods** with an HTTP method pragma, like `<get>`, as that denotes the execution context. The fact that the framework configures HTTP request with a corresponding HTTP method is a convenience. The `<path>` pragma is used for tracking which method handles the corresponding path. The fact that the request is configured with the resuling URL is, again, a convenience.

Lastly, in the event that /things/{thingId} represents a Thing with a lot of behavior, we could define it as a separate endpoint:

```smalltalk
Object subclass: #AcmeThingEndpoint
    uses: TWSEndpoint
    slots: { #thingId }
    package: 'Acme'

AcmeThingsEndpoint>>withId: aThingId
    ^ (self / AcmeThingEndpoint) 
        thingId: aThingId; 
        yourself

AcmeThingEndpoint class>>#endpointPath
    ^ AcmeThingsEndpoint endpointPath / '{thingId}'

AcmeThingEndpoint>>thingId
    ^ thingId

AcmeThingEndpoint>>thingId: anObject
    thingId := anObject

AcmeThingEndpoint>>value
    <get>
    ^ self execute

AcmeThingEndpoint>>updateWith: anUpdatedThing
    <post>
    ^ self execute: [ :http | http contents: anUpdatedThing ]
```

Your interface with /things now looks like:

```smalltalk
aThing := (client things withId: ‘someId') value.
aThing title: 'New title’.
aThing := (client things withId: aThing id) updateWith: aThing.
```

Or better yet,

```smalltalk
AcmeClient>>thingWithId: aThingId
    ^ self things withId: aThingId

thingEp := client thingWithId: 'someId'.
thingEp value in: [ :aThing | 
    aThing title: 'New Title'.
    thingEp updateWith: aThing ]
```

Another thing worth mentioning here is the ability of an endpoint to pass its state to another when using `#/` to derive endpoints. For example, if we were to define another endpoint that makes use of the `thingId`:

```smalltalk
Object subclass: #AcmeThingSiblingsEndpoint
    uses: TWSEndpoint;
    slots: { #thingId };
    package: ‘Acme’

AcmeThingSiblingsEndpoint class>>endpointPath
    ^ AcmeThingEndpoint endpointPath / #siblings

AcmeThingSiblingsEndpoint>>thingId: anObject
    thingId := anObject

AcmeThingEndpoint>>configureDerivedEndpoint: anotherEndpoint
    (anotherEndpoint respondsTo: #thingId:) ifTrue: [ anotherEndpoint thingId: self thingId ]

AcmeThingEndpoint>>siblings
    ^ self / AcmeThingSiblingsEndpoint

(client thingWithId: 'someId’) siblings.
(client thingWithId: 'someId’) / #siblings.
```

The last two lines would produce an identically configured instance of `AcmeThingSiblingsEndpoint`.

### Enumeration

When listing large collections, web services usually provide some sort of pagination mechanism, often in the form of: offset & limit, page & pageSize, or some sort of a cursor, or several. Eventually that translates to some attribute in the HTTP request. It would be nice if we could interact with this API as we do with normal collections in Smalltalk. 

This is where two additional structs come in: `TWSEnumeration` and `TWSCursor` traits. They allow one to easily setup an endpoint for enumeration. Let’s say that our /things endpoint allows enumeration using #page and #page_size query parameters.

```smalltalk
Object subclass: #AcmeThingsEndpoint
    uses: TWSEndpoint + TWSEnumeration
    slots: { }
    classVariables: { }
    package: 'Acme'
```

We need to implement just two methods: `#cursor` and `#next:with:`. The former needs to return an instance that uses `TWSCursor`, so let’s start there:

```smalltalk
Object subclass: #AcmePaginationCursor
    uses: TWSCursor
    slots: { #page. #pageSize. #hasMore }
    package: 'Acme'

AcmePaginationCursor>>initialize
    super initialize.
    page := 1.
    pageSize := 100.
    hasMore := true
```

Create accessors for the ivars, so that we can read/write cursor values. Now, to implement the required methods:

```smalltalk
AcmeThingsEndpoint>>cursor
    ^ AcmePaginationCursor new

AcmeThingsEndpoint>>#next: aLimit with: aCursor
    | result |
    result := self execute: [ :http |
        http request 
            queryAt: #page put: aCursor page;
            queryAt: #’page_size’ put: aCursor pageSize.
     ].
    (result size < aCursor pageSize)
        ifTrue: [ aCursor hasMore: false ]
        ifFalse: [ aCursor page: aCursor page + 1 ]
    ^ result
```

An enumerating endpoint behaves in a manner similar to a collection:

```smalltalk
client things select: #title.
client first: 100.
client select: [ :each | each isInteresting ].
client select: [ :each | each isInteresting ] max: 100.
client detect: [ :each | each isInteresting ] ifFound: [:found | found title ] ifNone: [ nil ].
“etc"
```

Whenever you call any of the enumerating methods, the endpoint will acquire a new instance of the cursor, via `#cursor`, and then call `#next:with:` until the cursor answers negatively to `#hasMore`, passing into it an optional limit and the running cursor as the two arguments. So, in our declaration of `#next:with:` we first configure the endpoint using the cursor data, then call an executing method, then updating the cursor for next generation, and return the result. The returned results are aggregated.
