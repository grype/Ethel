Extension { #name : #CompiledMethod }

{ #category : #'*Unrest' }
CompiledMethod >> isWSEndpointExecutionMethod [
	^ self wsEndpointHttpMethod isNotNil 
]

{ #category : #'*Unrest' }
CompiledMethod >> isWSEndpointReferencingMethod [
	^ self wsEndpointReferences isEmptyOrNil not
]

{ #category : #'*Unrest' }
CompiledMethod >> wsEndpointHttpMethod [
	| methods |

	self methodClass isWSEndpoint
		ifFalse: [ ^ nil ].
	methods := (self pragmas
		collect: [ :p | p keyword asLowercase asSymbol ])
		intersection: self methodClass supportedHttpMethods.
	^ methods ifEmpty: [ nil ] ifNotEmpty: [ methods first ]
]

{ #category : #'*Unrest' }
CompiledMethod >> wsEndpointPath [
	self methodClass isWSEndpoint
		ifFalse: [ ^ nil ].
	^ (self pragmaAt: self methodClass endpointPathPragma)
		ifNil: [ self methodClass endpointPath ]
		ifNotNil: [ :val | self methodClass endpointPath / val arguments first ]
]

{ #category : #'*Unrest' }
CompiledMethod >> wsEndpointReferences [
	^ self referencedClasses select: #isWSEndpoint
]
