Class {
	#name : #GHGraphqlClient,
	#superclass : #WSClient,
	#instVars : [
		'config'
	],
	#category : #'Ethel-Examples-Github-GraphQL'
}

{ #category : #'instance creation' }
GHGraphqlClient class >> default [
	^ self basicNew initializeWithConfiguration: GHApiConfiguration graphql
]

{ #category : #http }
GHGraphqlClient >> configureHttpClient: http [
	super configureHttpClient: http.
	http headerAt: #Authorization put: 'bearer ' , config authToken
]

{ #category : #initialization }
GHGraphqlClient >> initializeWithConfiguration: aConfig [
	self initialize.
	config := aConfig
]
