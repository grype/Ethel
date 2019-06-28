"
I am a general purpose web-based API client.

I am used for communicating with RESTful Services and the like. I can be used as-is, but do subclasses me if you'd like to make explicit a particular web-based API. I use ZincHTTPComponents for the actual HTTP transport, and collaborate with instances implementing ==TWSEndpoint== for configuring and executing HTTP requests.

Instantiate me #withUrl:

[[[ client := WSClient withUrl: 'https://api.example.com/v1'. ]]]

From there, you're typically traversing endpoints and executing requests:

[[[ response := (client / #things) get. ""GET /things"" ]]]

When deriving endpoints via #/ message, I will first attempt to find a concrete class that implements the resulting path, and if none could be found I'll create an instance of ==WSPluggableEndpoint==. You can also pass a concrete class that uses ==TWSEndpoint== as the argument.
	
When subclassing:
	* override #configureHttpClient: when there's a need to configure http transport with data not specific to a particular endpoint (endpoints get to configure transport separately)
	* override #validateResponse: for custom error handling
	* declare methods for traversing concrete endpoints if you'd like them to be discoverable

Instance Variables
	baseUrl:		<ZnUrl>
	httpConfiguration: <Block>

"
Class {
	#name : #WSClient,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'httpConfiguration'
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
		httpConfiguration: [ :http | 
			http
				contentReader: [ :aJsonString | NeoJSONReader fromString: aJsonString ];
				contentWriter: [ :obj | NeoJSONWriter toString: obj ] ];
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
WSClient >> configureOn: http [
	http url: self baseUrl.
	httpConfiguration ifNotNil: [ :aBlock | aBlock cull: http ]
]

{ #category : #http }
WSClient >> createHttpClient [
	| client |
	client := ZnClient new.
	self configureOn: client.
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
	^ self
		execute: anEndpoint
		with: nil
]

{ #category : #execution }
WSClient >> execute: anEndpoint with: aBlock [
	| http result |
	http := self createHttpClient.
	anEndpoint prepareForExecutingOn: http.
	anEndpoint configureOn: http.
	aBlock ifNotNil: [ :block | block cull: http ].
	self validateRequest: http request.
	result := http execute.
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

{ #category : #accessing }
WSClient >> httpConfiguration [
	^ httpConfiguration
]

{ #category : #accessing }
WSClient >> httpConfiguration: anObject [
	httpConfiguration := anObject
]

{ #category : #initialization }
WSClient >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]

{ #category : #http }
WSClient >> validateRequest: aRequest [
	(aRequest method isNotNil and: [ aRequest url isNotNil ]) ifFalse: [ WSHttpRequestError signal: aRequest ]
]

{ #category : #http }
WSClient >> validateResponse: aResponse [
	aResponse isSuccess
		ifFalse: [ WSHttpResponseError signal: aResponse ]
]
