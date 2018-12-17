Class {
	#name : #UnrestAnotherTestEndpoint,
	#superclass : #UnrestAbstractTestEndpoint,
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
UnrestAnotherTestEndpoint class >> endpointPath [
	^ Path / 'another-test'
]

{ #category : #tests }
UnrestAnotherTestEndpoint >> test [
	<endpoint>
	<get>
	^ self execute
]
