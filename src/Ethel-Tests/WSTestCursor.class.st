Class {
	#name : #WSTestCursor,
	#superclass : #Object,
	#traits : 'TWSEnumerationCursor',
	#classTraits : 'TWSEnumerationCursor classTrait',
	#instVars : [
		'offset',
		'total'
	],
	#category : #'Ethel-Tests-Models'
}

{ #category : #enumerating }
WSTestCursor >> hasMore [
	^ offset < total
]

{ #category : #accessing }
WSTestCursor >> offset [
	^ offset
]

{ #category : #accessing }
WSTestCursor >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
WSTestCursor >> total [
	^ total
]

{ #category : #accessing }
WSTestCursor >> total: anObject [
	total := anObject
]
