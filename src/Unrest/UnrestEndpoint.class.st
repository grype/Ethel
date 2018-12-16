"
I represent an abstract RESTful endpoint. Subclass me or use ==UnrestPluggableEndpoint==.

My subclasses can be either abstract or concrete. A concrete endpoint must define at least one concrete path. As a general rule, ensure that #endpointPath class-side method returns a ==Path==. Individual, instance-side methods can define specialized paths.

My primary concern is to encapsulate nouns and verbs of an endpoint using normal class semantics. For example,

UnrestEndpoint subclass: #MySearchEndpoint
	instanceVariableNames: 'query'
	classVariableNames: ''
	package: ''
	
MySearchEndpoint class>>endpointPath
	^ Path / 'search'
	
MySearchEndpoint>>query
	^ query

MySearchEndpoint>>query: aString
	^ query := aString
	
MySearchEndpoint>>execute
	<get>
	^ super execute
	
MyClient>>search
	^ self > (MySearchEndpoint on: self)

client search query: 'foobar'; execute. ""Instantiates MySearchEndpoint, sets query on it and executes the GET request""

You may have noticed the <get> pragma above. You other options are all other common HTTP methods like <delete> <post> <put> etc... In addition to that you can define a custom endpoint path for a specific method:

MyItemEndpoint class>>endpointPath
	^ Path / 'item'

MyItemEndpoint>>getById: anId
	<endpoint: '{anId}'>
	<get>
	^ self execute

client item getById: 1. ""GET /item/1""

The value of endpoint pragma is resolved using String>>format:, using named arguments. The names of arguments are resolved using the stack at the time of method execution. Which means they can also refer to instance variables...

I can be also chained with other endpoints:
  * Using #/ to instantiate ==UnrestPluggableEndpoint==
  * Using #> to instantiate a specific subclass of ==UnrestEndpoint==

Chaining is not inheritance, so if you're defining an endpoint for '/foo/bar' - you shouldn't be subclassing endpoint for '/foo' for that. However, it may make sense to define an abstract subclass of ==UnrestEndpoint== that would encapsulate common properties of a group of endpoints - say AuthenticatedEndpoint for configuring HTTP transport with authentication headers.
"
Class {
	#name : #UnrestEndpoint,
	#superclass : #Object,
	#instVars : [
		'unrest'
	],
	#category : #'Unrest-Core'
}

{ #category : #'accessing-context' }
UnrestEndpoint class >> endpointHttpMethodFromContext: aContext validMethods: aListOfMethods [
	| validMethods |
	validMethods := aListOfMethods collect: [ :each | each asLowercase asSymbol ].
	^ aContext method pragmas
		detect: [ :each | validMethods includes: each keyword asLowercase asSymbol ]
		ifFound: [ :val | val keyword ]
		ifNone: [ nil ]
]

{ #category : #accessing }
UnrestEndpoint class >> endpointPath [
	^ self subclassResponsibility
]

{ #category : #'accessing-context' }
UnrestEndpoint class >> endpointPathFromContext: aContext [
	^ (aContext method pragmaAt: #endpoint:) ifNotNil: [ :pragma | pragma arguments first ]
]

{ #category : #defaults }
UnrestEndpoint class >> endpointPragmas [
	^ #(#endpoint #endpoint:)
]

{ #category : #'accessing-context' }
UnrestEndpoint class >> endpointTempsFromContext: aContext [
	^ (aContext tempNames collect: [ :each | each -> (aContext tempNamed: each) ]) asDictionary
]

{ #category : #configuring }
UnrestEndpoint class >> endpointValuesFromContext: aContext [
	^ aContext receiver class allSlots
		ifEmpty: [ Dictionary new ]
		ifNotEmpty: [ :val | (val groupedBy: #name) collect: [ :each | each first read: aContext receiver ] ]
]

{ #category : #testing }
UnrestEndpoint class >> isAbstract [
	^ [self endpointPath isNil] on: Error do: [ true ]
]

{ #category : #testing }
UnrestEndpoint class >> isEndpointMethod: aCompiledMethod [
	^ aCompiledMethod pragmas
		detect: [ :pragma | self endpointPragmas includes: pragma keyword ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #'instance creation' }
UnrestEndpoint class >> on: unrestClient [
	^ self basicNew initializeOn: unrestClient
]

{ #category : #accessing }
UnrestEndpoint class >> referencingPaths [
	^ self referencingPathsWithMethods collect: #value
]

{ #category : #accessing }
UnrestEndpoint class >> referencingPathsWithMethods [
	^ ((Unrest endpointMethodsOn: self)
		collect: [ :aMethod | 
			aMethod
				->
					((aMethod key pragmaAt: #endpoint:)
						ifNil: [ self endpointPath ]
						ifNotNil: [ :val | self endpointPath / val arguments first ]) ]) asSet
]

{ #category : #endpoints }
UnrestEndpoint >> / aString [
	"Creates a new generic endpoint by appending a new path."

	^ (self > UnrestPluggableEndpoint)
		path: self endpointPath / aString;
		yourself
]

{ #category : #endpoints }
UnrestEndpoint >> > endPointClass [
	"Creates a new endpoint of specified class."

	| newEndpoint |

	newEndpoint := endPointClass on: unrest.
	self configureDerivedEndpoint: newEndpoint.
	^ newEndpoint 
]

{ #category : #configuring }
UnrestEndpoint >> configureDerivedEndpoint: anEndpoint [

]

{ #category : #configuring }
UnrestEndpoint >> configureOn: http [
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
UnrestEndpoint >> endpointPath [
	^ self class endpointPath 
]

{ #category : #executing }
UnrestEndpoint >> execute [
	^ unrest execute: self
]

{ #category : #configuring }
UnrestEndpoint >> executingContext [
	| sender |

	sender := thisContext sender.
	[ sender isNotNil and: [ (self class isEndpointMethod: sender method) not ] ]
		whileTrue: [ sender := sender sender ].

	^ sender
]

{ #category : #initialization }
UnrestEndpoint >> initializeOn: aClient [
	self initialize.
	unrest := aClient
]
