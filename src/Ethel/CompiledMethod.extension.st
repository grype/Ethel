Extension { #name : #CompiledMethod }

{ #category : #'*Ethel' }
CompiledMethod >> isWSEndpointExecutionMethod [
	^ self wsEndpointHttpMethod isNotNil 
]

{ #category : #'*Ethel' }
CompiledMethod >> isWSEndpointReferencingMethod [
	^ self wsEndpointReferences isEmptyOrNil not
]

{ #category : #'*Ethel' }
CompiledMethod >> wsEndpointHttpMethod [
	| methods |

	self methodClass isWSEndpoint
		ifFalse: [ ^ nil ].
	methods := (self pragmas
		collect: [ :p | p keyword asLowercase asSymbol ])
		intersection: self methodClass supportedHttpMethods.
	^ methods ifEmpty: [ nil ] ifNotEmpty: [ methods first ]
]

{ #category : #'*Ethel' }
CompiledMethod >> wsEndpointPath [
	self methodClass isWSEndpoint
		ifFalse: [ ^ nil ].
	self wsEndpointHttpMethod ifNil: [ ^ nil ].
	^ (self pragmaAt: self methodClass endpointPathPragma)
		ifNil: [ self methodClass endpointPath ]
		ifNotNil: [ :val | self methodClass endpointPath / val arguments first ]
]

{ #category : #'*Ethel' }
CompiledMethod >> wsEndpointReferences [
	^ self referencedClasses select: #isWSEndpoint
]
