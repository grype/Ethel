Class {
	#name : #WSTestClient,
	#superclass : #WSClient,
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
WSTestClient class >> baseUrl [
	^ 'http://example.com/' asUrl
]

{ #category : #accessing }
WSTestClient class >> default [
	^ self withUrl: self baseUrl 
]

{ #category : #endpoints }
WSTestClient >> collection [
	^ self > WSCollectionTestEndpoint  
]

{ #category : #endpoints }
WSTestClient >> test [
	^ self > WSTestEndpoint 
]
