Class {
	#name : #WSPluggableCursor,
	#superclass : #Object,
	#traits : 'TWSEnumerationCursor',
	#classTraits : 'TWSEnumerationCursor classTrait',
	#instVars : [
		'data',
		'hasMore'
	],
	#category : #'Ethel-Core'
}

{ #category : #accessing }
WSPluggableCursor >> data [
	^ data
]

{ #category : #accessing }
WSPluggableCursor >> data: anObject [
	data := anObject
]

{ #category : #enumerating }
WSPluggableCursor >> hasMore [
	^ hasMore
]

{ #category : #accessing }
WSPluggableCursor >> hasMore: anObject [
	hasMore := anObject
]

{ #category : #initialization }
WSPluggableCursor >> initialize [
	super initialize.
	hasMore := true.
	data := Dictionary new
]
