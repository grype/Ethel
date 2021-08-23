Class {
	#name : #WSDetachedTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSTestEndpoint',
	#classTraits : 'TWSTestEndpoint classTrait',
	#category : #'Ethel-Tests-Models'
}

{ #category : #accessing }
WSDetachedTestEndpoint >> endpointPath [
	^ WSTestEndpoint endpointPath / #'detached'
]

{ #category : #resolving }
WSDetachedTestEndpoint >> get [
	<get>
	^ self execute
]
