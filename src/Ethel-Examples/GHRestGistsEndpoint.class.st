Class {
	#name : #GHRestGistsEndpoint,
	#superclass : #GHRestAbstractGistsEndpoint,
	#instVars : [
		'gistData'
	],
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #accessing }
GHRestGistsEndpoint class >> endpointPath [
	^ Path / #gists
]

{ #category : #traversing }
GHRestGistsEndpoint >> mine [
	<get>
	^ self execute
]

{ #category : #traversing }
GHRestGistsEndpoint >> public [
	^ self / GHRestPublicGistsEndpoint 
]

{ #category : #traversing }
GHRestGistsEndpoint >> publicForUsername: aUsername [
	<path: '/users/{aUsername}/gists'>
	<get>
	^ self execute
]

{ #category : #traversing }
GHRestGistsEndpoint >> withId: anId [
	<path: '{anId}'>
	<get>
	^ self execute
]
