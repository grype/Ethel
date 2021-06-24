Extension { #name : #CompiledCode }

{ #category : #'*Ethel' }
CompiledCode >> isWSEndpointExecutionMethod [
	^ self wsEndpointHttpMethod isNotNil 
]

{ #category : #'*Ethel' }
CompiledCode >> isWSEndpointReferencingMethod [
	^ self wsEndpointReferences isEmptyOrNil not
]

{ #category : #'*Ethel' }
CompiledCode >> wsEndpointExecutionParams [
	self methodClass isWSEndpoint
		ifFalse: [ ^ nil ].
	^ (self pragmaAt: self methodClass endpointParamsPragma)
		ifNil: [ self ffiArgumentNames ]
		ifNotNil: [ :val | val arguments first ]
]

{ #category : #'*Ethel' }
CompiledCode >> wsEndpointHttpMethod [
	| methods |

	self methodClass isWSEndpoint
		ifFalse: [ ^ nil ].
	methods := (self pragmas
		collect: [ :p | p selector asLowercase asSymbol ])
		intersection: self methodClass supportedHttpMethods.
	^ methods ifEmpty: [ nil ] ifNotEmpty: [ methods first ]
]

{ #category : #'*Ethel' }
CompiledCode >> wsEndpointPath [
	self methodClass isWSEndpoint
		ifFalse: [ ^ nil ].
	self wsEndpointHttpMethod ifNil: [ ^ nil ].
	^ (self pragmaAt: self methodClass endpointPathPragma)
		ifNil: [ self methodClass endpointPath ]
		ifNotNil: [ :val | self methodClass endpointPath / val arguments first ]
]

{ #category : #'*Ethel' }
CompiledCode >> wsEndpointReferences [
	^ self referencedClasses select: #isWSEndpoint
]
