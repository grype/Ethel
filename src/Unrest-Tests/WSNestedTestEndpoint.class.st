Class {
	#name : #WSNestedTestEndpoint,
	#superclass : #WSTestEndpoint,
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
WSNestedTestEndpoint class >> endpointPath [
	^ super endpointPath  / #nested
]

{ #category : #'private-executing' }
WSNestedTestEndpoint >> get [
	<get>
	^ self execute
]
