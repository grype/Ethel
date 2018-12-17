Class {
	#name : #UnrestTestEndpoint,
	#superclass : #UnrestAbstractTestEndpoint,
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
UnrestTestEndpoint class >> endpointPath [
	^ Path / 'test'
]

{ #category : #api }
UnrestTestEndpoint >> get [
	<endpoint>
	<get>
	^ self execute
]
