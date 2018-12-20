Trait {
	#name : #TUnrestEnumerationCursor,
	#category : #'Unrest-Core'
}

{ #category : #enumerating }
TUnrestEnumerationCursor >> hasMore [
	^ self subclassResponsibility
]
