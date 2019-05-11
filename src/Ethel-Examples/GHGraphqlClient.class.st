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

{ #category : #accessing }
GHGraphqlClient >> baseUrl [ 
	^ config url
]

{ #category : #http }
GHGraphqlClient >> configureHttpClient: http [
	super configureHttpClient: http.
	http headerAt: #Authorization put: 'bearer ' , config authToken.
	http
		enforceHttpSuccess: true;
		enforceAcceptContentType: false;
		numberOfRetries: 3
]

{ #category : #initialization }
GHGraphqlClient >> initialize [
	super initialize.
	contentWriter := [ :obj | ZnEntity json: (NeoJSONWriter toString: obj) ].
	contentReader := [ :obj | NeoJSONReader fromString: obj ]
]

{ #category : #initialization }
GHGraphqlClient >> initializeWithConfiguration: aConfig [
	self initialize.
	config := aConfig
]

{ #category : #accessing }
GHGraphqlClient >> query: aQueryNodeOrCollection [
	^ (self / GHGraphqlRootEndpoint)
		query: aQueryNodeOrCollection;
		execute
]
