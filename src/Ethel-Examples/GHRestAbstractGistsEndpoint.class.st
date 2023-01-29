Class {
	#name : #GHRestAbstractGistsEndpoint,
	#superclass : #Object,
	#traits : 'TGHEndpoint',
	#classTraits : 'TGHEndpoint classTrait',
	#instVars : [
		'since'
	],
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #configuring }
GHRestAbstractGistsEndpoint >> configureOn: http [

	http request url
		clearPath;
		addPathSegments:
			(wsClient basePath resolve: self endpointPath) segments.

	since ifNotNil: [ :aDateAndTime | 
		http queryAt: #since put: aDateAndTime printString ]
]

{ #category : #accessing }
GHRestAbstractGistsEndpoint >> since [
	^ since
]

{ #category : #accessing }
GHRestAbstractGistsEndpoint >> since: anObject [
	since := anObject
]
