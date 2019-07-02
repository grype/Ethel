# Subclassing

When creating a dedicated client for a web service, it is best to subclass `WSClient` and define concrete endpoints, as that makes the code more manageable and easier to maintain. Let’s take GitHub’s Gist API as an example.

## The Client

Start by subclassing `WSClient`, capturing the base URL of the web service and the auth token. There are better ways of managing this data, but, for the sake of simplicity, we’re defining everything on the client itself.

```smalltalk
WSClient subclass: #GHRestClient
    slots: { #authToken }     
    classVariables: {  }     
    package: 'GitHub-API'

GHRestClient class>>#withAuthToken: aToken
    ^ self basicNew initializeWithAuthToken: aToken

GHRestClient>>#initializeWithAuthToken: aToken
    self initializeWithUrl: 'https://api.github.com'.
    authToken := aToken

GHRestClient>>#authToken
    ^ authToken
```

To configure HTTP requests for all endpoints - override `#configureOn:`

```smalltalk
GHRestClient>>#configureOn: http
    super configureOn: http
    http
        contentReader: [ :entity |
            (entity contentType sub asLowercase includesSubstring: 'json’)
                ifTrue: [ NeoJSONReader fromString: entity contents ]
                ifFalse: [ entity contents ] ].
    http headerAt: #Authorization put: 'token ' , authToken
```

Here we're adding an Authorization header and a content reader block, which marshals JSON responses. The `http` object is an instance of `ZnClient`.

To handle error responses, override `#validateResponse:` - the default implementation simply signals `WSHttpResponseError` for non-200 responses.

To validate requests prior to executing them, override `#validateRequest:` - the default implementation simply checks for HTTP method and URL to be there. 

For any other customization of endpoint execution - override `#execute:with:` method.

## The endpoints

Looking over the Gist API, it looks like we have:
* a list of personal gists via GET /gists
* a list of all gists for a user via GET /users/{username}/gists
* individual gists via GET /gists/{gistId}
* a paginated list of public gists via GET /gists/public

This is a good place to start, because we could start reasoning about “gists” in terms of endpoints and our interaction with them. First, let's define `GHGistsEndpoint` as the basis of our interactions with gists.

```smalltalk
Object subclass: #GHGistsEndpoint
    uses: TWSEndpoint
    slots: { }
    classVariables: { }
    package: 'GitHub-API'

GHGistsEndpoint class>>#endpointPath
    ^ Path / #gists

GHRestClient>>#gists
    ^ self / GHGistsEndpoint
```

Using **/gists** for `#endpointPath` since all of the functionality, which we intend to implement on top of this endpoint, resides relative to this path. It’s a good idea to also provide a method for instantiating the new endpoint from the client - that makes the client's interface more succinct and intuitive.

To list personal gists, all we need to do is execute a GET request for the endpoint:

```smalltalk
GHGistsEndpoint>>#mine
    <get>
    ^ self execute
```

The `<get>` pragma distinguishes this as the **executing method**, while also configuring the HTTP request with GET method. The result should be an array of dictionaries representing gists. This result is already materialized thanks to the content reader configured in `GHRestClient>>#configureOn:`.

To get a request by ID:

```smalltalk
GHGistsEndpoint>>#withId: anId
    <path: '{anId}'>
    <get>
    ^ self execute
```

To get list of user’s gists:

```smalltalk
GHGistsEndpoint>>#publicForUsername: aUsername    
    <path: '/users/{aUsername}/gists'>
    <get>     
    ^ self execute
```

One notable difference here is the addition of the `<path>` pragma. The value of the pragma will be resolved against the class-side `#endpointPath`, resulting in e.g. **/gists/{anId}** and **/users/{aUsername}/gists**. These paths will also be formatted within the execution context, in this case substituting '{..}' with the method arguments. Let's take what we've created so far for a quick spin:

```smalltalk
client := GHRestClient default.

"Returns list of personal gists"
client gists mine.

"Returns gist with given ID"
client gists withId: 'foo'.

"Return John Doe's public gists"
client gists publicForUsername: 'johndoe'.
```

Now on to the paginated list of public gists. To make use of Ethel's collection-like API for paginated endpoints, we need to implement a cursor and a new endpoint:

Cursor:

```smalltalk
Object subclass: #GHPagingCursor
    uses: TWSEnumerationCursor
    slots: { #page. #pageSize. #hasMore }
    classVariables: {  }
    package: 'GitHub-API'

GHPagingCursor>>#initialize
    super initialize.
    page := 1.
    pageSize := 10.
    hasMore := true
```

Be sure to create accessors for the ivars, so that we can mutate the cursor while paginating. The `#hasMore` variable captures whether the cursor is at the end.

Public Gists endpoint:

```smalltalk
Object subclass: #GHRestPublicGistsEndpoint
    uses: TWSEndpoint + TWSEnumeration
    slots: { #page. #pageSize }
    classVariables: {  }
    package: 'GitHub-API'

GHRestPublicGistsEndpoint class>>#endpointPath
    ^ Path / #gists / #public

GHRestPublicGistsEndpoint>>#configureOn: http
    http queryAt: #page put: page.
    http queryAt: #per_page put: pageSize

GHRestPublicGistsEndpoint>>#cursor
    ^ GHPagingCursor new

GHRestPublicGistsEndpoint>>#next: aLimit with: aCursor
    | result |
    page := aCursor page.
    pageSize := (aLimit ifNil: [ aCursor pageSize ]) min: self maxPageSize.
    result := self execute.
    (result isNotNil and: [ result size >= pageSize ])
        ifTrue: [ aCursor page: aCursor page + 1 ]
        ifFalse: [ aCursor hasMore: false ].
    ^ result

GHRestPublicGistsEndpoint>>#maxPageSize
    ^ 100

GHRestPublicGistsEndpoint>>#execute
    <get>
    ^ wsClient execute: self
```

The endpoint manages `#page` and `#pageSize` properties, which are used to configure the http request's query data. For the endpoint to be enumerable, the class must use `TWSEnumeration`, and the instance must provide a cursor instance via `#cursor`. We're utilizing the newly added `GHPagingCursor`. What remains is an implementation to fetch a single page, which is done by overriding `#next:with:` method. There, we simply configure the endpoint using the cursor data, execute the request, update the cursor and return the result of the execution. Notice we're overriding the endpoint's trait implementation of `#execute` - we need to do include the `<get>` pragma and tell the client to execute the endpoint. 

Finally, let's create a method to instantiate the public gists endpoint:

```smalltalk
GHGistsEndpoint>>#public
    ^ self / GHRestPublicGistsEndpoint
```

And now it's possible to do things like:

```smalltalk
client gists public first: 10.
client gists public select: #yourself.
client gists public select: #yourself max: 10.
client gists public detect: [ :each | ... ].
```

