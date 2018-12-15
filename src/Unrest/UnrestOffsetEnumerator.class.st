Class {
	#name : #UnrestOffsetEnumerator,
	#superclass : #UnrestEnumerator,
	#instVars : [
		'offset'
	],
	#category : #'Unrest-Core'
}

{ #category : #initialization }
UnrestOffsetEnumerator >> initialize [
	super initialize.
	offset := 0
]

{ #category : #accessing }
UnrestOffsetEnumerator >> offset [
	^ offset
]

{ #category : #accessing }
UnrestOffsetEnumerator >> offset: anObject [
	offset := anObject
]
