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
GHRestClient >> configure [
	super configure.
	WSCurrentContext value ifNotNil: [ :context | 
		| http newPath |

		http := context transport.
		http contentReader: [ :entity | 
			(entity contentType sub asLowercase includesSubstring: 'json')
				ifTrue: [ NeoJSONReader fromString: entity contents ]
				ifFalse: [ entity contents ] ].
		http headerAt: #Authorization put: 'token ' , config authToken.
		newPath := self basePath resolve: context endpoint endpointPath.
		http request url clearPath.
		http request url addPathSegments: newPath segments ]
]

{ #category : #execution }
GHRestClient >> execute: anEndpoint with: anExecBlock [
	^ [ super execute: anEndpoint with: anExecBlock ]
		on: WSHttpResponseError
		do: [ :err | 
			err response code = 401
				ifTrue: [ UIManager default
						alert: 'Be sure to set API token in Settings/Tools/Ethel'
						title: 'Unauthorized'.
						err resume ]
				ifFalse: [ err signal ] ]
]

{ #category : #traversing }
GHRestClient >> gists [
	^ self / GHRestGistsEndpoint 
]

{ #category : #initialization }
GHRestClient >> initializeWithConfiguration: aConfig [
	self initialize.
	config := aConfig
]
