Extension { #name : #CompiledMethod }

{ #category : #'*Ethel' }
CompiledMethod >> isWSEndpointExecutionMethod [

	| cls |
	cls := self methodClass.
	^ cls isWSEndpoint and: [ 
		  self pragmas
			  detect: [ :pragma | 
				  WSClient httpMethods includes:
					  (pragma selector asString copyWithoutAll: ':') ]
			  ifFound: [ true ]
			  ifNone: [ false ] ]
]

{ #category : #'*Ethel' }
CompiledMethod >> wsEndpointAccessor [
	"Return an endpoint accessor. Determined in the following order:
	1. <get: '/path/somewhere'> pragma, or
	2. <get> & <path: '/path/somewhere'> pragmas (legacy)"

	| supportedMethods method path |

	supportedMethods := WSClient httpMethods.

	method := nil.
	path := self methodClass pathPrefix ifNil: [ Path root ].

	^ self pragmas
		  detect: [ :pragma | 
			  method := pragma selector asString copyWithoutAll: ':'.
			  supportedMethods includes: method ]
		  ifFound: [ :pragma | 
			  | arguments |

			  arguments := pragma arguments ifEmpty: [ 
				               (self pragmaAt: WSClient endpointPathPragma) 
					               ifNotNil: [ :pathPragma | pathPragma arguments ] ].
			  arguments isEmptyOrNil ifFalse: [ 
				  path := path / arguments first asString ].
			  WSEndpointAccessor
				  method: method
				  path: path ]
		  ifNone: [ nil ]
]

{ #category : #'*Ethel' }
CompiledMethod >> wsEndpointReferences [
	^ self referencedClasses select: #isWSEndpoint
]
