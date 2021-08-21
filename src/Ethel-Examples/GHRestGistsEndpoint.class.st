Class {
	#name : #GHRestGistsEndpoint,
	#superclass : #GHRestAbstractGistsEndpoint,
	#instVars : [
		'gistData'
	],
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #traversing }
GHRestGistsEndpoint >> createWithDescription: aDescription isPublic: isPublic nameFiles: aFilesDict [
	"aFilesDict should be { #fileName -> 'file content'... }"

	<post>
	gistData := {(#description -> aDescription).
	(#isPublic -> isPublic).
	(#files
		-> (aFilesDict collect: [ :each | {(#content -> each)} asDictionary ]))}
		asDictionary.
	self execute
]

{ #category : #accessing }
GHRestGistsEndpoint >> endpointPath [
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
	<get: '/users/{aUsername}/gists'>
	^ self execute
]

{ #category : #traversing }
GHRestGistsEndpoint >> withId: anId [
	<get: '{anId}'>
	^ self execute
]
