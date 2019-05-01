Class {
	#name : #GHApiConfiguration,
	#superclass : #Object,
	#instVars : [
		'url',
		'authToken'
	],
	#category : #'Ethel-Examples-Github-Common'
}

{ #category : #defaults }
GHApiConfiguration class >> defaultAuthToken [
	^ 'I should have put my OAuth token here...'
]

{ #category : #'instance creation' }
GHApiConfiguration class >> graphql [
	^ self new
		url: 'https://api.github.com/graphql' asUrl;
		authToken: self defaultAuthToken;
		yourself
]

{ #category : #'instance creation' }
GHApiConfiguration class >> rest [
	^ self new
		url: 'https://api.github.com/' asUrl;
		authToken: self defaultAuthToken;
		yourself
]

{ #category : #accessing }
GHApiConfiguration >> authToken [
	^ authToken
]

{ #category : #accessing }
GHApiConfiguration >> authToken: anObject [
	authToken := anObject
]

{ #category : #accessing }
GHApiConfiguration >> url [
	^ url
]

{ #category : #accessing }
GHApiConfiguration >> url: anObject [
	url := anObject
]
