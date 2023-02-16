"
I am a general purpose web-based API client.

I am used for communicating with RESTful Services and the like. I can't be used as-is and need to be subclassed. I only provide the machinery required for executing endpoints (objects that use `TWSEndpoint`). There's one pre-defined subclass of mine that provides a generic API for making requests. Its name is `WSDynamicClient` and it's great for scripting requests. If you're interested in implementing a specific web API - it's best to subclass me.

I use ZincHTTPComponents for the actual HTTP transport, and I collaborate with instances implementing `TWSEndpoint` for configuring and executing HTTP requests.

## Subclassing notes	
	* override #configure when there's a need to configure http transport with data not specific to a particular endpoint (endpoints get to configure transport separately)
	* override #validateResponse: for custom error handling
	* as a matter of convenience - declare methods for traversing/instantiating concrete endpoints

Instance Variables
	baseUrl:		<ZnUrl>
	httpConfiguration: <Block>

"
Class {
	#name : #WSClient,
	#superclass : #Object,
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

	^ self subclassResponsibility 
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

{ #category : #validating }
WSClient >> validateRequest: aRequest [
	(aRequest method isNotNil and: [ aRequest url isNotNil ]) ifFalse: [ WSHttpRequestError signal: aRequest ]
]

{ #category : #validating }
WSClient >> validateResponse: aResponse [
	aResponse isSuccess
		ifFalse: [ WSHttpResponseError signal: aResponse ]
]
