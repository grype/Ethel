Class {
	#name : #GHRestClient,
	#superclass : #WSClient,
	#instVars : [
		'config'
	],
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #'instance creation' }
GHRestClient class >> default [
	^ self basicNew initializeWithConfiguration: GHApiConfiguration rest
]

{ #category : #accessing }
GHRestClient >> baseUrl [
	^ config url
]

{ #category : #http }
GHRestClient >> configureHttpClient: http [
	super configureHttpClient: http.
	http headerAt: #Authorization put: 'token ' , config authToken
]

{ #category : #traversing }
GHRestClient >> gists [
	^ self / GHRestGistsEndpoint 
]

{ #category : #initialization }
GHRestClient >> initialize [
	super initialize.
	contentReader := [ :json | NeoJSONReader fromString: json ]
]

{ #category : #initialization }
GHRestClient >> initializeWithConfiguration: aConfig [
	self initialize.
	config := aConfig
]
