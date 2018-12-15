Class {
	#name : #UnrestEnumerator,
	#superclass : #Object,
	#instVars : [
		'block',
		'cursor'
	],
	#category : #'Unrest-Core'
}

{ #category : #accessing }
UnrestEnumerator >> cursor [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
UnrestEnumerator >> next [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
UnrestEnumerator >> previous [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
UnrestEnumerator >> upToEnd [
	[ self cursor atEnd ] whileFalse: [ self next ]
]

{ #category : #enumerating }
UnrestEnumerator >> upToStart [
	[ self cursor atStart ] whileFalse: [ self previous ]
]
