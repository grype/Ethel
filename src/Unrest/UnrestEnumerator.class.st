Class {
	#name : #UnrestEnumerator,
	#superclass : #Object,
	#instVars : [
		'block',
		'cursor'
	],
	#category : #'Unrest-Core'
}

{ #category : #enumerating }
UnrestEnumerator >> all: aBlock [
	^ [ self hasMore ] whileTrue: [ self next: aBlock ]
]

{ #category : #enumerating }
UnrestEnumerator >> hasMore [
	^ self subclassResponsibility
]

{ #category : #enumerating }
UnrestEnumerator >> next: aBlock [
	^ self subclassResponsibility 
]
