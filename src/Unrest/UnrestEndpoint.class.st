Class {
	#name : #UnrestEndpoint,
	#superclass : #Object,
	#instVars : [
		'unrest'
	],
	#category : #Unrest
}

{ #category : #defaults }
UnrestEndpoint class >> endpointPragmas [
	^ #(#endpoint #endpoint:)
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
	| effectivePath endpointMethod contextValues segments |

	effectivePath := self endpointPath.
	endpointMethod := self executingEndpointMethod.
	endpointMethod
		ifNotNil: [ :method | 
			(endpointMethod pragmaAt: #endpoint:) ifNotNil: [ :pragma | pragma arguments ifNotEmpty: [ :val | effectivePath := Path / val first ] ].
			endpointMethod pragmas detect: [ :each | unrest allowedHttpMethods includes: each keyword asLowercase asSymbol ] ifFound: [ :found | http method: found keyword asUppercase asSymbol ] ].
	contextValues := (thisContext receiver class allSlots groupedBy: #name) collect: [ :each | each first read: self ].
	segments := effectivePath segments collect: [:segment | segment format: contextValues ].
	http url: unrest baseUrl / segments
]

{ #category : #accessing }
UnrestEndpoint >> endpointPath [
	^ self subclassResponsibility
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
