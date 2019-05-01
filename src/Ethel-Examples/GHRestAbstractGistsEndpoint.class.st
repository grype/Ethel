Class {
	#name : #GHRestAbstractGistsEndpoint,
	#superclass : #Object,
	#traits : 'TWSEndpoint',
	#classTraits : 'TWSEndpoint classTrait',
	#instVars : [
		'since'
	],
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #configuring }
GHRestAbstractGistsEndpoint >> configureOn: http [
	since
		ifNotNil: [ :aDateAndTime | http queryAt: #since put: aDateAndTime printString ]
]

{ #category : #accessing }
GHRestAbstractGistsEndpoint >> since [
	^ since
]

{ #category : #accessing }
GHRestAbstractGistsEndpoint >> since: anObject [
	since := anObject
]
