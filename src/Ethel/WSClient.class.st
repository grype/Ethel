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
		'baseUrl'
	],
	#category : #'Ethel-Core'
}

{ #category : #accessing }
WSClient class >> endpoints [
	"Return collection of endpoint classes associated with this client type. 
	By default, this returns all of the endpoint classes referenced by this and by all discovered classes"
	^ self derivedWSEndpoints
]

{ #category : #http }
WSClient class >> supportedHttpMethods [
	"Returns array of supported HTTP methods. These are used to identify and verify executing endpoint methods - any such method should declare a corresponding pragma."
	^ #(#get #post #put #patch #delete #options)
]

{ #category : #icons }
WSClient class >> systemIconName [
	^ #remote
]

{ #category : #'building - transport' }
WSClient class >> transportVisitorClass [
	^ WSZincTransportVisitor
]

{ #category : #'instance creation' }
WSClient class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #endpoints }
WSClient >> / aPathOrEndpoint [
	^ aPathOrEndpoint isWSEndpoint
		  ifTrue: [ aPathOrEndpoint on: self ]
		  ifFalse: [ 
			  (WSPluggableEndpoint on: self)
				  path: (aPathOrEndpoint isString
						   ifTrue: [ Path from: aPathOrEndpoint ]
						   ifFalse: [ aPathOrEndpoint ]);
				  yourself ]
]

{ #category : #accessing }
WSClient >> basePath [

	^ (self baseUrl path ifEmpty: [ nil ])
		  ifNil: [ Path root ]
		  ifNotNil: [ :val | Path root / val ]
]

{ #category : #accessing }
WSClient >> baseUrl [
	^ baseUrl
]

{ #category : #configuring }
WSClient >> configure [
	self configureRequestUrl.
	self configureBuilders.
	self configureDeprecated
]

{ #category : #configuring }
WSClient >> configureBuilders [
	| pragmas builders visitor |

	WSCurrentContext value ifNotNil: [ :context | 
		pragmas := context sender method pragmas.
		builders := TWSTransportBuilder users flatCollect: [ :builderClass | 
			            pragmas
				            collect: [ :aPragma | 
				            builderClass fromPragma: aPragma ]
				            thenSelect: #isNotNil ].
		visitor := self class transportVisitorClass new.
		builders do: [ :builder | builder accept: visitor ] ]
]

{ #category : #configuring }
WSClient >> configureDeprecated [
	WSCurrentContext value ifNotNil: [ :context | 
		(self respondsTo: #configureOn:) ifTrue: [ 
			Deprecation new
				context: thisContext sender;
				explanation: 'Use #configure instead';
				signal.
			self perform: #configureOn: with: context transport ] ]
]

{ #category : #configuring }
WSClient >> configureRequestUrl [
	WSCurrentContext value ifNotNil: [ :context | 
		context transport url: self baseUrl ]
]

{ #category : #execution }
WSClient >> createHttpClient [

	^ ZnClient new
]

{ #category : #execution }
WSClient >> execute: anEndpoint [
	^ self
		execute: anEndpoint
		with: nil
]

{ #category : #execution }
WSClient >> execute: anEndpoint with: aBlock [
	| http result context |

	http := self createHttpClient.
	context := WSContext new
		           transport: http;
		           endpoint: anEndpoint;
		           yourself.
	result := nil.

	WSCurrentContext value: context during: [ 
		self configure.
		anEndpoint configure.
		aBlock ifNotNil: [ :block | block cull: http ].
		self validateRequest: http request.
		Smalltalk
			at: #WrapperSignal
			ifPresent: [ :signalClass | signalClass emit: http ].
		result := http execute.
		self validateResponse: http response ].

	^ result
]

{ #category : #initialization }
WSClient >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]

{ #category : #validating }
WSClient >> validateRequest: aRequest [
	(aRequest method isNotNil and: [ aRequest url isNotNil ]) ifFalse: [ WSHttpRequestError signal: aRequest ]
]

{ #category : #validating }
WSClient >> validateResponse: aResponse [
	aResponse isSuccess
		ifFalse: [ WSHttpResponseError signal: aResponse ]
]
