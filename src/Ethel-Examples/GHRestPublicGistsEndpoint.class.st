Class {
	#name : #GHRestPublicGistsEndpoint,
	#superclass : #GHRestAbstractGistsEndpoint,
	#traits : 'TGHPagingEndpoint',
	#classTraits : 'TGHPagingEndpoint classTrait',
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #accessing }
GHRestPublicGistsEndpoint class >> pathPrefix [
	^ Path / #gists / #public
]

{ #category : #configuring }
GHRestPublicGistsEndpoint >> configureOn: http [
	super configureOn: http.
	self configurePaginationOn: http
]

{ #category : #accessing }
GHRestPublicGistsEndpoint >> endpointPath [
	^ Path / #gists / #public
]

{ #category : #enumerating }
GHRestPublicGistsEndpoint >> nextPage [
	<get>
	^ self execute
]
