Extension { #name : #Class }

{ #category : #'*Unrest' }
Class >> isUnrestEndpoint [
	^ self withAllSuperclasses
		detect: [ :each | each traitComposition includesTrait: TUnrestEndpoint ]
		ifFound: [ true ]
		ifNone: [ false ]
]
