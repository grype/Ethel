Class {
	#name : #WSDetachedTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSTestEndpoint',
	#classTraits : 'TWSTestEndpoint classTrait',
	#category : #'Ethel-Tests-Models'
}

{ #category : #'as yet unclassified' }
WSDetachedTestEndpoint >> endpointPath [
	^ WSTestEndpoint class pathPrefix / #'detached'
]

{ #category : #resolving }
WSDetachedTestEndpoint >> get [
	<get>
	^ self execute
]
