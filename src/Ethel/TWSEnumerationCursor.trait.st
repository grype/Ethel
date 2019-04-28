"
I represent an enumeration cursor.

I am used by ==TWSEnumerating== in order to determine whether enumeration is complete, which is done by asking #hasMore after each enumeration.
"
Trait {
	#name : #TWSEnumerationCursor,
	#category : #'Ethel-Core'
}

{ #category : #enumerating }
TWSEnumerationCursor >> hasMore [
	^ self subclassResponsibility
]
