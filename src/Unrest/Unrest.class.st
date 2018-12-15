"
I am a RESTful network client. I exist to simplify creation and maintenance of RESTful clients.

I can be used as-is for scripting purposes. However, if you'd like to reify a particular API - do subclass me.

I use ZincHTTPComponents for actual transport, and collaborate with instances of ==UnrestEndpoint== for configuring and executing HTTP requests.

Instantiate me #withUrl:

client := Unrest withUrl: ZnUrl fromString: 'https://api.example.com/v1'.

By default I don't provide any special content reader or writer. If, for example, you're dealing
with reading JSON response, you can configure me with:

client contentWriter: [ :obj | ZnEntity json: obj asJson ].

From there, you're typically traversing endpoints and executing requests. 

response := (client / 'interesting-data') get.

When scripting, I create instances of ==UnrestPluggableEndpoint==, which maintains a ==Dictionary== accessible via #data, and provides convenience methods for various HTTP methods. The above example amounts to a GET request to 'http://api.example.com/v1/interesting-data'. You can easily craft the pluggable endpoint with various particulars such as headers and data.

response := (client / 'things') 
	headerAt: #Authorization put: '...'; 
	dataAt: #thing put: aThing;
	post.
	
When subclassing, it helps to provide access to all top-level endpoints from within the subclass like this:

UnrestSubclass>>thingsEndpoint
	^ self > ThingsEndpoint
	
Override #configureHttpClient: for providing custom configuration of the http transport. Transport configuration is a two-phase process, where I occupy the first phase, via #configureHttpClient:, and the endpoint - the second phase. This way you can keep my configuration general...

For custom error handling, override #validateResponse:.

See comment on ==UnrestEndpoint== for creating custom endpoints.

Instance Variables
	baseUrl:		<ZnUrl>
	contentReader:		<Block>
	contentWriter:		<Block>

"
Class {
	#name : #Unrest,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'contentReader',
		'contentWriter'
	],
	#category : #'Unrest-Core'
}

{ #category : #introspection }
Unrest class >> associatedEndpointClasses [
	| methods referencedClasses rootEndpointClass |

	methods := self endpointMethods.
	referencedClasses := ((methods flatCollect: [ :each | each value ])
		collect: #value) asSet.
	rootEndpointClass := (referencedClasses
		flatCollect: [ :each | each withAllSuperclasses ])
		select: [ :each | each superclass == UnrestEndpoint ].
	^ (rootEndpointClass flatCollect: #withAllSubclasses)
]

{ #category : #introspection }
Unrest class >> endpointMethods [
	^ self endpointMethodsOn: self
]

{ #category : #introspection }
Unrest class >> endpointMethodsOn: aClass [
	^ (aClass methods
		collect: [ :aMethod | 
			aMethod
				->
					(aMethod allLiterals
						select: [ :aLiteral | aLiteral value isClass and: [ aLiteral value inheritsFrom: UnrestEndpoint ] ]) ])
		select: [ :each | each value isNotEmpty ]
]

{ #category : #'instance creation' }
Unrest class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #endpoints }
Unrest >> / aString [
	"Creates a new generic endpoint."
	^ (UnrestPluggableEndpoint on: self) path: (Path / aString); yourself
]

{ #category : #endpoints }
Unrest >> > endPointClass [
	"Creates a new endpoint of specified class."
	^ endPointClass on: self
]

{ #category : #http }
Unrest >> allowedHttpMethods [
	^ #(#get #post #put #patch #delete #options)
]

{ #category : #accessing }
Unrest >> baseUrl [
	^ baseUrl
]

{ #category : #http }
Unrest >> configureHttpClient: http [
	contentReader ifNotNil: [ :val | http contentReader: val ].
	contentWriter ifNotNil: [ :val | http contentWriter: val ]
]

{ #category : #accessing }
Unrest >> contentReader [
	^ contentReader
]

{ #category : #accessing }
Unrest >> contentReader: anObject [
	contentReader := anObject
]

{ #category : #accessing }
Unrest >> contentWriter [
	^ contentWriter
]

{ #category : #accessing }
Unrest >> contentWriter: anObject [
	contentWriter := anObject
]

{ #category : #http }
Unrest >> createHttpClient [
	| client |
	client := ZnClient new.
	self configureHttpClient: client.
	^ client
]

{ #category : #execution }
Unrest >> execute [
	| sender |
	self deprecated: 'Not used anymore'.
	sender := thisContext sender.
	(sender methodClass inheritsFrom: UnrestEndpoint) ifFalse: [ UnrestError signal: ('Cannot be executed by {1} because it is not an UnrestEndpoint!' format: { sender class greaseString}) ].
	self execute: sender
]

{ #category : #execution }
Unrest >> execute: anEndpoint [
	| http result |

	http := self createHttpClient.
	anEndpoint configureOn: http.
	self validateRequest: http request.
	result := http execute.
	self validateResponse: http response.
	^ result
]

{ #category : #accessing }
Unrest >> implementorsOfPath: aPath [
	| pathsAndMethods |

	pathsAndMethods := (self class associatedEndpointClasses
		reject: [ :each | each isAbstract ])
		flatCollect: [ :each | each referencingPathsWithMethods ].
	^ pathsAndMethods
		select: [ :each | each value = aPath ]
		thenCollect: [ :each | each key key ]
]

{ #category : #initialization }
Unrest >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]

{ #category : #http }
Unrest >> validateMethod: aMethod [
	| method |
	method := aMethod asLowercase.
	^ (self allowedHttpMethods includes: method)
		ifTrue: [ method asSymbol ]
		ifFalse:
			[ UnrestError signal: ('Tried to perform invalid Method "{1}"' format: {aMethod}) ]
]

{ #category : #http }
Unrest >> validateRequest: aRequest [
	(aRequest method isNotNil and: [ aRequest url isNotNil ]) ifFalse: [ UnrestError signal: 'Invalid HTTP Request' ]
]

{ #category : #http }
Unrest >> validateResponse: aResponse [
	aResponse isSuccess
		ifTrue: [ ^ true ].
	UnrestError
		signal:
			('{1}: {2}'
				format:
					{aResponse statusLine code.
					aResponse statusLine reason}).
	^ false
]
