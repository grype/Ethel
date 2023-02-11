Class {
	#name : #GHRestPublicGistsEndpoint,
	#superclass : #GHRestAbstractGistsEndpoint,
	#traits : 'TGHPagingEndpoint',
	#classTraits : 'TGHPagingEndpoint classTrait',
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #'as yet unclassified' }
GHRestPublicGistsEndpoint >> configure [
	super configure.
	WSCurrentContext value ifNotNil: [ :context | 
		self configurePaginationOn: context transport ]
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
