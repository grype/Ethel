"
I encapsulate basic behavior of a web-based API endpoint.

An endpoint object is meant to capture a specific functionality or a limited set of similar functionalities of a web-based service. In the simplest form an endpoint: 
	a) captures approapriate request parameters (e.g. using instance variables); 
	b) defines messages that execute various aspects of the endpoint;
	c) defines messages that instantiate other endpoints.
	
For example, a RESTful endpoint would capture nouns in instance variables and define verbs in terms of various messages.

I work in tandem with ==WSClient== to configure an http transport and execute requests. There's also ==WSPluggableEndpoint== which is commonly used for scripting.

Instance Variables
	wsClient:		<WSClient>

Example:

[[[
			Object subclass: #MyEndpoint
				uses: TWSEndpoint
				instanceVariableNames: 'query limit'
				classVariableNames: ''
				package: 'MyPackage'
				
			MyEndoint class>>endpointPath
				^ Path / 'search'
				
			MyEndpoint>>configureOn: http
				http addQuery: { #query -> query. #limit -> limit } asDictionary.

			MyEndpoint>>search
				<get>
				^ self execute
]]]

A few pointers when subclassing:
	1. On the class side define #endpointPath that returns a path relative to ==WSClient>>baseUrl==. This is required for organizational reason. You can override this on the instance side.
	2. Optionally, override #configureOn: to configure HTTP prior to executing requests.
	3. When defining request-executing methods: 
		- include pragma for the HTTP method to be used: e.g. <get> (List of valid method symbols is defined in ==WSClient class>>#supportedHttpMethods)
		- optionally, you can override the final request path using <path: '/some/path'> pragma.
		- be sure to call #execute at some point - that will prepare and execute appropriate HTTP request. 
	   
"
Trait {
	#name : #TWSEndpoint,
	#instVars : [
		'wsClient'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
TWSEndpoint classSide >> on: wsClient [
	^ self basicNew initializeOn: wsClient
]

{ #category : #'accessing-context' }
TWSEndpoint classSide >> supportedHttpMethods [
	^ WSClient supportedHttpMethods 
]

{ #category : #icons }
TWSEndpoint classSide >> systemIconName [
	^ self isTrait
		ifTrue: [ super systemIconName ]
		ifFalse: [ #hierarchy ]
]

{ #category : #endpoints }
TWSEndpoint >> / aStringOrEndpoint [
	| ep |

	ep := self wsClient / aStringOrEndpoint.
	(self respondsTo: #configureDerivedEndpoint:) ifTrue: [ 
		Deprecation new
			context: thisContext sender;
			explanation: 'Override #/ instead';
			signal.
		self perform: #configureDerivedEndpoint: with: ep ].
	^ ep
]

{ #category : #'building - transport' }
TWSEndpoint >> configure [
	| pragmas builders visitor |

	WSCurrentContext value ifNotNil: [ :context | 
		pragmas := context sender method pragmas.
		builders := TWSTransportBuilder users flatCollect: [ :builderClass | 
			            pragmas
				            collect: [ :aPragma | 
				            builderClass fromPragma: aPragma ]
				            thenSelect: #isNotNil ].
		visitor := self transportVisitorClass new.
		builders do: [ :builder | builder accept: visitor ].
		"-- Call deprecated method. This will be removed in the future --"
		(self respondsTo: #configureOn:) ifTrue: [ 
			self configureOn: context transport ] ]
]

{ #category : #executing }
TWSEndpoint >> execute [
	^ self execute: nil
]

{ #category : #executing }
TWSEndpoint >> execute: anExecBlock [
	^ wsClient execute: self with: anExecBlock 
]

{ #category : #initialization }
TWSEndpoint >> initializeOn: aClient [
	self initialize.
	wsClient := aClient
]

{ #category : #'building - transport' }
TWSEndpoint >> transportVisitorClass [
	^ WSZincTransportVisitor
]

{ #category : #accessing }
TWSEndpoint >> wsClient [
	^ wsClient
]
