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
