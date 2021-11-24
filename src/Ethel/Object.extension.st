Extension { #name : #Object }

{ #category : #'*Ethel' }
Object >> isWSEndpoint [
	^ self class isWSEndpoint
]

{ #category : #'*Ethel' }
Object >> isWSPluggableEndpoint [
	^ false
]
