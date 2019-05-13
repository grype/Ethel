Class {
	#name : #WSMapItem,
	#superclass : #Object,
	#instVars : [
		'implementors'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
WSMapItem class >> with: aCollectionOfImplementors [
	^ self basicNew initializeWith: aCollectionOfImplementors
]

{ #category : #comparing }
WSMapItem >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ implementors = anObject implementors
]

{ #category : #testing }
WSMapItem >> containsExecutingMethod [
	^ implementors
		detect: [ :each | (each isKindOf: CompiledMethod) and: [ each isWSEndpointExecutionMethod ] ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #comparing }
WSMapItem >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ implementors hash
]

{ #category : #accessing }
WSMapItem >> implementors [
	^ implementors
]

{ #category : #initialization }
WSMapItem >> initializeWith: aCollectionOfImplementors [
	self initialize.
	implementors := aCollectionOfImplementors isCollection
		ifTrue: [ aCollectionOfImplementors asSet ]
		ifFalse: [ Set with: aCollectionOfImplementors ]
]
