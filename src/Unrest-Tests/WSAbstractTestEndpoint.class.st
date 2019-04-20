Class {
	#name : #WSAbstractTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSEndpoint',
	#classTraits : 'TWSEndpoint classTrait',
	#category : #'Unrest-Tests'
}

{ #category : #accessing }
WSAbstractTestEndpoint class >> referencingPathsWithMethods [
	^ ((WSClient endpointMethodsOn: self)
		collect: [ :aMethod | 
			aMethod
				->
					((aMethod key pragmaAt: #endpoint:)
						ifNil: [ self endpointPath ]
						ifNotNil: [ :val | self endpointPath / val arguments first ]) ]) asSet
]

{ #category : #configuring }
WSAbstractTestEndpoint >> prepareForExecutingOn: http [
	| effectivePath contextValues segments |

	effectivePath := self endpointPath.
	contextValues := self class endpointValuesFromContext: thisContext.

	self executingContext
		ifNotNil: [ :context | 
			(self class endpointPathFromContext: context) ifNotNil: [ :val | effectivePath := effectivePath / val ].
			(self class endpointHttpMethodFromContext: context validMethods: wsClient class supportedHttpMethods)
				ifNotNil: [ :val | http method: val asUppercase asSymbol ].
			(self class endpointTempsFromContext: context) ifNotEmpty: [ :val | contextValues addAll: val ] ].

	segments := effectivePath segments collect: [ :segment | segment format: contextValues ].
	http url: wsClient baseUrl / segments
]
