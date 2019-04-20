"
I encapsulate basic behavior of a web-based API endpoint.

An endpoint object is meant to capture a specific functionality or a limited set of similar functionalities of a web-based service. In its simplest form - it would define instance variables for configuring an endpoint, and define messages to execute various aspects of the endpoint. In RESTful terms - instance variables are nouns and messages are verbs.

I work in tandem with ==Unrest== to configure an http transport and execute requests. There's also ==UnrestPluggableEndpoint== which is commonly used when scripting.

Instance Variables
	unrest:		<Unrest>

Example:

Object subclass: #MyEndpoint
	uses: TUnrestEndpoint
	instanceVariableNames: 'query limit'
	classVariableNames: ''
	package: 'MyPackage'

MyEndoint class>>endpointPath
	^ Path / 'search'
	
MyEndpoint>>configureOn: http
	http addQuery: { #query -> query. #limit -> limit } asDictionary.

MyEndpoint>>search
	<endpoint>
	<get>
	^ self execute

A few things to keep in my mind when subclassing:
	1. On the class side define #endpointPath that return a path relative to ==Unrest>>baseUrl==. This is required for organizational reason. Return root path, if there's nothing more specific. You can override this on the instance side.
	2. Override #configureOn: to configure HTTP prior to executing requests.
	4. When defining request-executing methods, you may include any of the following pragmas:
	   <endpoint> - Indicates request-executing method (used for organizing endpoint)
	   <endpoint: 'some/path'> - Indicates executing method and overrides value returned by #endpointPath
	   <get> or <Any HTTP method> - Specifies HTTP method, applied after #configureOn:
	5. Call TUnrestEndpoint>>execute to initiate request
	   
"
Trait {
	#name : #TWSEndpoint,
	#instVars : [
		'wsClient'
	],
	#category : #'Unrest-Core'
}

{ #category : #'accessing-context' }
TWSEndpoint classSide >> endpointHttpMethodFromContext: aContext validMethods: aListOfMethods [
	| validMethods |
	validMethods := aListOfMethods collect: [ :each | each asLowercase asSymbol ].
	^ aContext method pragmas
		detect: [ :each | validMethods includes: each keyword asLowercase asSymbol ]
		ifFound: [ :val | val keyword ]
		ifNone: [ nil ]
]

{ #category : #accessing }
TWSEndpoint classSide >> endpointPath [
	^ self subclassResponsibility
]

{ #category : #'accessing-context' }
TWSEndpoint classSide >> endpointPathFromContext: aContext [
	^ aContext method isWSEndpointMethod
		ifTrue: [ aContext method wsEndpointPath ]
		ifFalse: [ nil ]
]

{ #category : #'accessing-context' }
TWSEndpoint classSide >> endpointPathPragma [
	^ WSClient endpointPathPragma 
]

{ #category : #'accessing-context' }
TWSEndpoint classSide >> endpointTempsFromContext: aContext [
	^ (aContext tempNames collect: [ :each | each -> (aContext tempNamed: each) ]) asDictionary
]

{ #category : #configuring }
TWSEndpoint classSide >> endpointValuesFromContext: aContext [
	^ aContext receiver class allSlots
		ifEmpty: [ Dictionary new ]
		ifNotEmpty: [ :val | (val groupedBy: #name) collect: [ :each | each first read: aContext receiver ] ]
]

{ #category : #testing }
TWSEndpoint classSide >> isAbstractEndpoint [
	^ [ self endpointPath isNil ]
		on: Exception
		do: [ :err | true ]
]

{ #category : #'instance creation' }
TWSEndpoint classSide >> on: unrestClient [
	^ self basicNew initializeOn: unrestClient
]

{ #category : #accessing }
TWSEndpoint classSide >> referencingPaths [
	^ self referencingPathsWithMethods collect: #value
]

{ #category : #accessing }
TWSEndpoint classSide >> referencingPathsWithMethods [
	^ ((WSClient endpointMethodsOn: self)
		collect: [ :aMethod | aMethod -> aMethod wsEndpointPath pathString ]) asSet
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
TWSEndpoint >> / aString [
	"Creates a new generic endpoint by appending a new path."

	^ (self > WSPluggableEndpoint)
		path: self endpointPath / aString;
		yourself
]

{ #category : #endpoints }
TWSEndpoint >> > endPointClass [
	"Creates a new endpoint of specified class."

	| newEndpoint |

	newEndpoint := endPointClass on: wsClient.
	self configureDerivedEndpoint: newEndpoint.
	^ newEndpoint 
]

{ #category : #configuring }
TWSEndpoint >> configureDerivedEndpoint: anEndpoint [
	"Configures newly derived endpoint"
]

{ #category : #configuring }
TWSEndpoint >> configureOn: http [
	"Configures http transport prior to execution"
]

{ #category : #accessing }
TWSEndpoint >> endpointPath [
	^ self class endpointPath 
]

{ #category : #executing }
TWSEndpoint >> execute [
	^ wsClient execute: self
]

{ #category : #executing }
TWSEndpoint >> executingContext [
	| sender |

	sender := thisContext sender.
	[ sender isNotNil and: [ sender method isWSEndpointMethod not ] ]
		whileTrue: [ sender := sender sender ].

	^ sender
]

{ #category : #initialization }
TWSEndpoint >> initializeOn: aClient [
	self initialize.
	wsClient := aClient
]

{ #category : #configuring }
TWSEndpoint >> prepareForExecutingOn: http [
	| effectivePath contextValues segments |

	effectivePath := self endpointPath.
	contextValues := self class endpointValuesFromContext: thisContext.

	self executingContext
		ifNotNil: [ :context | 
			(self class endpointPathFromContext: context) ifNotNil: [ :val | effectivePath := val ].
			(self class endpointHttpMethodFromContext: context validMethods: wsClient class supportedHttpMethods)
				ifNotNil: [ :val | http method: val asUppercase asSymbol ].
			(self class endpointTempsFromContext: context) ifNotEmpty: [ :val | contextValues addAll: val ] ].

	segments := effectivePath segments collect: [ :segment | segment format: contextValues ].
	http url: wsClient baseUrl / segments
]

{ #category : #accessing }
TWSEndpoint >> wsClient [
	^ wsClient
]
