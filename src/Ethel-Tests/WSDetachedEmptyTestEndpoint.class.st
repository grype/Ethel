"
This endpoint class should NOT be referenced by the client!
"
Class {
	#name : #WSDetachedEmptyTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSTestEndpoint',
	#classTraits : 'TWSTestEndpoint classTrait',
	#category : #'Ethel-Tests-Models'
}

{ #category : #accessing }
WSDetachedEmptyTestEndpoint >> endpointPath [
	^ WSTestEndpoint endpointPath / #'detached-empty'
]
