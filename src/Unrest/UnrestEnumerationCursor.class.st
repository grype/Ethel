Class {
	#name : #UnrestEnumerationCursor,
	#superclass : #Object,
	#category : #'Unrest-Core'
}

{ #category : #accessing }
UnrestEnumerationCursor >> atEnd [
	^ self subclassResponsibility
]

{ #category : #accessing }
UnrestEnumerationCursor >> atStart [
	^ self subclassResponsibility
]
