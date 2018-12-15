Class {
	#name : #UnrestOffsetCursor,
	#superclass : #UnrestEnumerationCursor,
	#instVars : [
		'index',
		'atStart',
		'atEnd'
	],
	#category : #'Unrest-Core'
}

{ #category : #accessing }
UnrestOffsetCursor >> atEnd [
	^ atEnd
]

{ #category : #accessing }
UnrestOffsetCursor >> atEnd: anObject [
	atEnd := anObject
]

{ #category : #accessing }
UnrestOffsetCursor >> atStart [
	^ index == 0
]

{ #category : #accessing }
UnrestOffsetCursor >> index [
	^ index
]

{ #category : #accessing }
UnrestOffsetCursor >> index: anObject [
	index := anObject
]

{ #category : #initialization }
UnrestOffsetCursor >> initialize [
	super initialize.
	index := 0.
	atStart := true.
	atEnd := false
]
