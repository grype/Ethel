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

{ #category : #endpoints }
UnrestTestClient >> another [
	^ self > UnrestAnotherTestEndpoint  
]

{ #category : #endpoints }
UnrestTestClient >> test [
	^ self > UnrestTestEndpoint 
]
