Class {
	#name : #Unrest,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'contentReader',
		'contentWriter',
		'headers'
	],
	#category : #Unrest
}

{ #category : #defaults }
Unrest class >> endpointClass [
	^ UnrestEndpoint 
]

{ #category : #'instance creation' }
Unrest class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #endpoints }
Unrest >> / aPath [
	^ self endpointClass withClient: self url: self baseUrl / aPath
]

{ #category : #accessing }
Unrest >> baseUrl [
	^ baseUrl
]

{ #category : #private }
Unrest >> configureHttpClient: http [
	http url: baseUrl.
	self contentWriter ifNotNil: [ :val | http contentWriter: val ].
	self contentReader ifNotNil: [ :val | http contentReader: val ].
	self headers ifNotNil: [ :val | http headerAddAll: val ]
]

{ #category : #accessing }
Unrest >> contentReader [
	^ contentReader
]

{ #category : #accessing }
Unrest >> contentReader: anObject [
	contentReader := anObject
]

{ #category : #accessing }
Unrest >> contentWriter [
	^ contentWriter
]

{ #category : #accessing }
Unrest >> contentWriter: anObject [
	contentWriter := anObject
]

{ #category : #private }
Unrest >> createHttpClient [
	| client |
	client := ZnClient new.
	self configureHttpClient: client.
	^ client
]

{ #category : #accessing }
Unrest >> endpointClass [
	^ self class endpointClass
]

{ #category : #accessing }
Unrest >> headers [
	^ headers
]

{ #category : #accessing }
Unrest >> headers: anObject [
	headers := anObject
]

{ #category : #initialization }
Unrest >> initialize [
	super initialize.
	headers := Dictionary new
]

{ #category : #initialization }
Unrest >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]
