Class {
	#name : #UnrestAbstractTestEndpoint,
	#superclass : #UnrestEndpoint,
	#instVars : [
		'headers'
	],
	#category : #'Unrest-Tests-Models'
}

{ #category : #configuring }
UnrestAbstractTestEndpoint >> configureDerivedEndpoint: anEndpoint [
	(anEndpoint isKindOf: UnrestAbstractTestEndpoint)
		ifTrue: [ headers associationsDo: [ :each | anEndpoint headers add: each ] ]
]

{ #category : #accessing }
UnrestAbstractTestEndpoint >> headers [
	^ headers
]

{ #category : #accessing }
UnrestAbstractTestEndpoint >> headers: anObject [
	headers := anObject
]

{ #category : #initialization }
UnrestAbstractTestEndpoint >> initialize [
	super initialize.
	headers := Dictionary new.
	self className in: [ :className | headers at: className put: ('Added by {1}' format: {className}) ]
]
