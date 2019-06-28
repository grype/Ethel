Extension { #name : #Behavior }

{ #category : #'*Ethel-Tools' }
Behavior >> wsUmlSortOrder [
	^ self isTrait
		ifTrue: [ 0 ]
		ifFalse: [ 0.1 ]
]
