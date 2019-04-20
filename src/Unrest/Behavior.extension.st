Extension { #name : #Behavior }

{ #category : #'*Unrest' }
Behavior >> isWSEndpoint [
	^ self withAllSuperclasses
		detect: [ :each | each traitComposition includesTrait: TWSEndpoint ]
		ifFound: [ true ]
		ifNone: [ false ]
]
