Class {
	#name : #UnrestTestCursor,
	#superclass : #Object,
	#traits : 'TUnrestEnumerationCursor',
	#classTraits : 'TUnrestEnumerationCursor classTrait',
	#instVars : [
		'offset',
		'total'
	],
	#category : #'Unrest-Tests-Models'
}

{ #category : #enumerating }
UnrestTestCursor >> hasMore [
	^ offset < total
]

{ #category : #accessing }
UnrestTestCursor >> offset [
	^ offset
]

{ #category : #accessing }
UnrestTestCursor >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
UnrestTestCursor >> total [
	^ total
]

{ #category : #accessing }
UnrestTestCursor >> total: anObject [
	total := anObject
]
