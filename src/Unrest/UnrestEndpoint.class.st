Class {
	#name : #UnrestEndpoint,
	#superclass : #Object,
	#instVars : [
		'unrest'
	],
	#category : #Unrest
}

{ #category : #accessing }
UnrestEndpoint class >> endpointPath [
	^ self subclassResponsibility
]

{ #category : #defaults }
UnrestEndpoint class >> endpointPragmas [
	^ #(#endpoint #endpoint:)
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
	^ ((Unrest endpointMethodsOn: self)
		collect: [ :aMethod | 
			(aMethod key pragmaAt: #endpoint:)
				ifNil: [ self endpointPath ]
				ifNotNil: [ :val | self endpointPath / val arguments first ] ]) asSet
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
	^ endPointClass on: unrest
]

{ #category : #configuring }
UnrestEndpoint >> configureOn: http [
	| effectivePath contextValues segments |

	effectivePath := self endpointPath.

	contextValues := (thisContext receiver class allSlots groupedBy: #name) collect: [ :each | each first read: self ].

	self executingEndpointMethod
		ifNotNil: [ :method | 
			| methodContext |

			(method pragmaAt: #endpoint:) ifNotNil: [ :pragma | pragma arguments ifNotEmpty: [ :val | effectivePath := effectivePath / val first ] ].
			method pragmas detect: [ :each | unrest allowedHttpMethods includes: each keyword asLowercase asSymbol ] ifFound: [ :found | http method: found keyword asUppercase asSymbol ].
			methodContext := thisContext.
			[ methodContext method isNotNil and: [ methodContext method ~= method ] ] whileTrue: [ methodContext := methodContext sender ].
			methodContext method == method
				ifTrue: [ | temps |

					temps := (methodContext tempNames collect: [ :each | each -> (methodContext tempNamed: each) ]) asDictionary.
					contextValues addAll: temps ] ].

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
UnrestEndpoint >> executingEndpointMethod [
	| sender |

	sender := thisContext sender.
	[ sender isNotNil and: [ (self class isEndpointMethod: sender method) not ] ]
		whileTrue: [ sender := sender sender ].

	^ sender ifNotNil: [ :val | val method ]
]

{ #category : #initialization }
UnrestEndpoint >> initializeOn: aClient [
	self initialize.
	unrest := aClient
]
