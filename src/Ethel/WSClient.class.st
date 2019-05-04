"
I am a general purpose web-based API client.

I am good at talking to RESTful APIs and the like, and can be used as-is for scripting purposes. However, if you'd like to make explicit a particular web-based API - do subclass me. I use ZincHTTPComponents for actual transport, and collaborate with instances implementing ==WSEndpoint== for configuring and executing HTTP requests.

Instantiate me #withUrl:

[[[ client := WSClient withUrl: 'https://api.example.com/v1'. ]]]

By default I don't provide any special content reader or writer. If, for example, you're dealing
with reading JSON responses, you can configure me with:

[[[ 
			client 
				contentReader: [ :aJsonString | NeoJSONReader fromString: aJsonString ]; 
				contentWriter: [ :obj | ZnEntity json: NeoJSONWriter toString: obj ]. 
]]]

For convenience, ==WSClient class>>jsonWithUrl:== creates an instance with that configuration.

From there, you're typically traversing endpoints and executing requests:

[[[ response := (client / #things) get. ""GET /things"" ]]]

When scripting, I create instances of ==WSPluggableEndpoint==, which provides ways for setting custom headers and data, as well as convenience methods for various HTTP methods.

[[[ 
			response := (client / #things) 
				headerAt: #Authorization put: '...';
				data: aThing;
				post. 
]]]
	
When subclassing:
	* override #configureHttpClient: when there's a need to configure http transport with data not specific to a particular endpoint (endpoints get to configure transport separately)
	* override #validateResponse: for custom error handling

It also helps to provide access to all top-level endpoints from within the subclass, e.g.:

[[[ MyClient>>things
	^ self / ThingsEndpoint ]]]
	
This way you could chain endpoints starting with the client:

client foo bar get. ""GET /foo/bar""
client foo bar title: 'Title'; body: 'Body'; post. ""POST /foo/bar {data from #bar endpoint}""

Taking this approach has two benefits: 1) explicitly defined paths are easier to discover and use when using message sends; 2) by default, WSClient class>>#endpoints returns list of endpoint classes that can be derived from the class by following references to classes that implement ==TWSEndpoint==. That information is used to discover all relevant endpoint when inspecting my instances.

Instance Variables
	baseUrl:		<ZnUrl>
	contentReader:		<Block>
	contentWriter:		<Block>

"
Class {
	#name : #WSClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'contentReader',
		'contentWriter'
	],
	#category : #'Ethel-Core'
}

{ #category : #defaults }
WSClient class >> endpointPathPragma [
	"Default pragma used by methods of an endpoint class that override its #endpointPath. Endpoint classes can override this method..."
	^ #path:
]

{ #category : #accessing }
WSClient class >> endpoints [
	"Return collection of endpoint classes associated with this client type. 
	By default, this returns all of the endpoint classes referenced by this and by all discovered classes"
	^ self derivedWSEndpoints
]

{ #category : #'instance creation' }
WSClient class >> jsonWithUrl: aUrl [
	^ (self withUrl: aUrl)
		contentReader: [ :aJsonString | NeoJSONReader fromString: aJsonString ];
		contentWriter: [ :obj | NeoJSONWriter toString: obj ];
		yourself
]

{ #category : #accessing }
WSClient class >> pathReferences [
	"Returns all path references found in related endpoint classes"
	^ (self endpoints flatCollect: #pathReferences) asSet
]

{ #category : #http }
WSClient class >> supportedHttpMethods [
	"Returns array of supported HTTP methods. These are used to identify and verify executing endpoint methods - any such method should declare a corresponding pragma."
	^ #(#get #post #put #patch #delete #options)
]

{ #category : #'instance creation' }
WSClient class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #endpoints }
WSClient >> / aPathObject [
	^ aPathObject isWSEndpoint
		ifTrue: [ aPathObject on: self ]
		ifFalse: [ self
				endpointForPath:
					((aPathObject isKindOf: Path)
						ifTrue: [ aPathObject asResolvedBy: Path root ]
						ifFalse: [ Path / aPathObject asString ]) ]
]

{ #category : #accessing }
WSClient >> baseUrl [
	^ baseUrl
]

{ #category : #http }
WSClient >> configureHttpClient: http [
	contentReader ifNotNil: [ :val | http contentReader: val ].
	contentWriter ifNotNil: [ :val | http contentWriter: val ]
]

{ #category : #accessing }
WSClient >> contentReader [
	^ contentReader
]

{ #category : #accessing }
WSClient >> contentReader: anObject [
	contentReader := anObject
]

{ #category : #accessing }
WSClient >> contentWriter [
	^ contentWriter
]

{ #category : #accessing }
WSClient >> contentWriter: anObject [
	contentWriter := anObject
]

{ #category : #http }
WSClient >> createHttpClient [
	| client |
	client := ZnClient new.
	self configureHttpClient: client.
	^ client
]

{ #category : #endpoints }
WSClient >> endpointForPath: aPath [
	| endpoints |

	endpoints := self class endpoints
		select: [ :aClass | 
			aClass ~= WSPluggableEndpoint
				and: [ aClass endpointPath matches: aPath ] ].
	endpoints size > 1
		ifTrue: [ WSAmbiguousEndpointPathError signal: aPath ].
	^ endpoints
		ifEmpty: [ (WSPluggableEndpoint on: self)
				path: aPath;
				yourself ]
		ifNotEmpty: [ :val | val anyOne on: self ]
]

{ #category : #execution }
WSClient >> execute: anEndpoint [
	| http result |

	http := self createHttpClient.
	anEndpoint prepareForExecutingOn: http.
	anEndpoint configureOn: http.
	self validateRequest: http request.
	result := self performExecuteOn: http.
	self validateResponse: http response.
	^ result
]

{ #category : #accessing }
WSClient >> executorsOfPath: aPath [
	| pathsAndMethods |

	pathsAndMethods := self class endpoints
		flatCollect: [ :each | each pathReferences ].
	^ pathsAndMethods
		select: [ :each | each value matches: aPath ]
		thenCollect: [ :each | each key ]
]

{ #category : #initialization }
WSClient >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]

{ #category : #execution }
WSClient >> performExecuteOn: http [
	^ http execute
]

{ #category : #http }
WSClient >> validateRequest: aRequest [
	(aRequest method isNotNil and: [ aRequest url isNotNil ]) ifFalse: [ WSError signal: 'Invalid HTTP Request' ]
]

{ #category : #http }
WSClient >> validateResponse: aResponse [
	aResponse isSuccess
		ifTrue: [ ^ true ].
	WSError
		signal:
			('{1}: {2}'
				format:
					{aResponse statusLine code.
					aResponse statusLine reason}).
	^ false
]
