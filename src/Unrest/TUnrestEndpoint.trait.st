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
	#name : #TUnrestEndpoint,
	#instVars : [
		'unrest'
	],
	#category : #'Unrest-Core'
}

{ #category : #'accessing-context' }
TUnrestEndpoint classSide >> endpointHttpMethodFromContext: aContext validMethods: aListOfMethods [
	| validMethods |
	validMethods := aListOfMethods collect: [ :each | each asLowercase asSymbol ].
	^ aContext method pragmas
		detect: [ :each | validMethods includes: each keyword asLowercase asSymbol ]
		ifFound: [ :val | val keyword ]
		ifNone: [ nil ]
]

{ #category : #accessing }
TUnrestEndpoint classSide >> endpointPath [
	^ self subclassResponsibility
]

{ #category : #'accessing-context' }
TUnrestEndpoint classSide >> endpointPathFromContext: aContext [
	^ (aContext method pragmaAt: #endpoint:) ifNotNil: [ :pragma | pragma arguments first ]
]

{ #category : #defaults }
TUnrestEndpoint classSide >> endpointPragmas [
	^ #(#endpoint #endpoint:)
]

{ #category : #'accessing-context' }
TUnrestEndpoint classSide >> endpointTempsFromContext: aContext [
	^ (aContext tempNames collect: [ :each | each -> (aContext tempNamed: each) ]) asDictionary
]

{ #category : #configuring }
TUnrestEndpoint classSide >> endpointValuesFromContext: aContext [
	^ aContext receiver class allSlots
		ifEmpty: [ Dictionary new ]
		ifNotEmpty: [ :val | (val groupedBy: #name) collect: [ :each | each first read: aContext receiver ] ]
]

{ #category : #testing }
TUnrestEndpoint classSide >> isAbstract [
	^ [ self endpointPath isNil ]
		on: Exception
		do: [ :err | true ]
]

{ #category : #testing }
TUnrestEndpoint classSide >> isAbstractEndpoint [
	^ [ self endpointPath isNil ]
		on: Exception
		do: [ :err | true ]
]

{ #category : #testing }
TUnrestEndpoint classSide >> isEndpointMethod: aCompiledMethod [
	^ aCompiledMethod pragmas
		detect: [ :pragma | self endpointPragmas includes: pragma keyword ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #'instance creation' }
TUnrestEndpoint classSide >> on: unrestClient [
	^ self basicNew initializeOn: unrestClient
]

{ #category : #accessing }
TUnrestEndpoint classSide >> referencingPaths [
	^ self referencingPathsWithMethods collect: #value
]

{ #category : #accessing }
TUnrestEndpoint classSide >> referencingPathsWithMethods [
	^ ((Unrest endpointMethodsOn: self)
		collect: [ :aMethod | 
			aMethod
				->
					((aMethod key pragmaAt: #endpoint:)
						ifNil: [ self endpointPath ]
						ifNotNil: [ :val | self endpointPath / val arguments first ]) ]) asSet
]

{ #category : #icons }
TUnrestEndpoint classSide >> systemIconName [
	^ self isTrait
		ifTrue: [ super systemIconName ]
		ifFalse: [ #hierarchy ]
]

{ #category : #endpoints }
TUnrestEndpoint >> / aString [
	"Creates a new generic endpoint by appending a new path."

	^ (self > UnrestPluggableEndpoint)
		path: self endpointPath / aString;
		yourself
]

{ #category : #endpoints }
TUnrestEndpoint >> > endPointClass [
	"Creates a new endpoint of specified class."

	| newEndpoint |

	newEndpoint := endPointClass on: unrest.
	self configureDerivedEndpoint: newEndpoint.
	^ newEndpoint 
]

{ #category : #configuring }
TUnrestEndpoint >> configureDerivedEndpoint: anEndpoint [
	"Configures newly derived endpoint"
]

{ #category : #configuring }
TUnrestEndpoint >> configureOn: http [
	"Configures http transport prior to execution"
]

{ #category : #accessing }
TUnrestEndpoint >> endpointPath [
	^ self class endpointPath 
]

{ #category : #executing }
TUnrestEndpoint >> execute [
	^ unrest execute: self
]

{ #category : #executing }
TUnrestEndpoint >> executingContext [
	| sender |

	sender := thisContext sender.
	[ sender isNotNil and: [ (self class isEndpointMethod: sender method) not ] ]
		whileTrue: [ sender := sender sender ].

	^ sender
]

{ #category : #initialization }
TUnrestEndpoint >> initializeOn: aClient [
	self initialize.
	unrest := aClient
]

{ #category : #configuring }
TUnrestEndpoint >> prepareForExecutingOn: http [
	| effectivePath contextValues segments |

	effectivePath := self endpointPath.
	contextValues := self class endpointValuesFromContext: thisContext.

	self executingContext
		ifNotNil: [ :context | 
			(self class endpointPathFromContext: context) ifNotNil: [ :val | effectivePath := effectivePath / val ].
			(self class endpointHttpMethodFromContext: context validMethods: unrest allowedHttpMethods)
				ifNotNil: [ :val | http method: val asUppercase asSymbol ].
			(self class endpointTempsFromContext: context) ifNotEmpty: [ :val | contextValues addAll: val ] ].

	segments := effectivePath segments collect: [ :segment | segment format: contextValues ].
	http url: unrest baseUrl / segments
]

{ #category : #accessing }
TUnrestEndpoint >> unrest [
	^ unrest
]
