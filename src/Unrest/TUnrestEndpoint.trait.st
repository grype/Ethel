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
