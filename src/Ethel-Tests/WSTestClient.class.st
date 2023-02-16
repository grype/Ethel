Class {
	#name : #WSTestClient,
	#superclass : #WSClient,
	#instVars : [
		'baseUrl'
	],
	#category : #'Ethel-Tests-Models'
}

{ #category : #accessing }
WSTestClient class >> baseUrl [
	^ 'http://example.com/base/path' asUrl
]

{ #category : #accessing }
WSTestClient class >> default [

	^ self new baseUrl: self baseUrl
]

{ #category : #accessing }
WSTestClient class >> endpoints [
	^ super endpoints
		, (self package classes select: #isWSEndpoint) reject: #isTrait
]

{ #category : #accessing }
WSTestClient >> baseUrl [

	^ baseUrl
]

{ #category : #accessing }
WSTestClient >> baseUrl: anObject [

	baseUrl := anObject
]

{ #category : #endpoints }
WSTestClient >> collection [
	^ self / WSCollectionTestEndpoint  
]

{ #category : #endpoints }
WSTestClient >> test [
	^ self / WSTestEndpoint 
]
