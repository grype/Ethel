Class {
	#name : #WSNestedTestEndpoint,
	#superclass : #WSTestEndpoint,
	#category : #'Ethel-Tests-Models'
}

{ #category : #accessing }
WSNestedTestEndpoint >> endpointPath [
	^ super endpointPath  / #nested
]

{ #category : #'private-executing' }
WSNestedTestEndpoint >> get [
	<get>
	^ self execute
]
