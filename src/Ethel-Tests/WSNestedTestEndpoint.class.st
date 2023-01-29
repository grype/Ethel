Class {
	#name : #WSNestedTestEndpoint,
	#superclass : #WSTestEndpoint,
	#category : #'Ethel-Tests-Models'
}

{ #category : #'private-executing' }
WSNestedTestEndpoint >> get [
	<get>
	^ self execute
]
