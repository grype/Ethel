"
I represent an enumeration cursor.

I am used by ==TUnrestEnumerating== in order to determine whether enumeration has reached the end, which is done by asking #hasMore after each enumeration.
"
Trait {
	#name : #TUnrestEnumerationCursor,
	#category : #'Unrest-Core'
}

{ #category : #enumerating }
TUnrestEnumerationCursor >> hasMore [
	^ self subclassResponsibility
]
