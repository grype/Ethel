Class {
	#name : #UnrestTestClient,
	#superclass : #Unrest,
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
UnrestTestClient class >> baseUrl [
	^ 'http://example.com/' asUrl
]

{ #category : #accessing }
UnrestTestClient class >> default [
	^ self withUrl: self baseUrl 
]

{ #category : #tests }
UnrestTestClient >> test [
	^ self > UnrestTestEndpoint 
]
