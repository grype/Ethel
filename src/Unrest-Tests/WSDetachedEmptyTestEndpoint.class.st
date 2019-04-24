"
This endpoint class should NOT be referenced by the client!
"
Class {
	#name : #WSDetachedEmptyTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSTestEndpoint',
	#classTraits : 'TWSTestEndpoint classTrait',
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
WSDetachedEmptyTestEndpoint class >> endpointPath [
	^ WSTestEndpoint endpointPath / #'detached-empty'
]
