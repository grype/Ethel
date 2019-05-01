Class {
	#name : #GHRestGistsEndpoint,
	#superclass : #GHRestAbstractGistsEndpoint,
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #accessing }
GHRestGistsEndpoint class >> endpointPath [
	^ Path / #gist
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
