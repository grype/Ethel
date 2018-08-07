Class {
	#name : #UnrestPluggableEndpoint,
	#superclass : #UnrestEndpoint,
	#instVars : [
		'path',
		'data',
		'method',
		'headers'
	],
	#category : #'Unrest-Core'
}

{ #category : #configuring }
UnrestPluggableEndpoint >> configureDerivedEndpoint: anEndpoint [
	anEndpoint headers: headers
]

{ #category : #configuring }
UnrestPluggableEndpoint >> configureOn: http [
	super configureOn: http.
	method = #get
		ifTrue: [ http queryAddAll: data ]
		ifFalse: [ http contents: data ].
	http method: method greaseString asUppercase asSymbol.
	http headerAddAll: headers
]

{ #category : #accessing }
UnrestPluggableEndpoint >> data [
	^ data
]

{ #category : #data }
UnrestPluggableEndpoint >> dataAt: aPropertyName put: aValue [
	data at: aPropertyName put: aValue
]

{ #category : #data }
UnrestPluggableEndpoint >> dataRemoveAll [
	data removeAll
]

{ #category : #data }
UnrestPluggableEndpoint >> dataRemoveAt: aPropertyName [
	data remove: aPropertyName ifAbsent: [  ]
]

{ #category : #api }
UnrestPluggableEndpoint >> delete [
	^ self executeHttpMethod: #delete
]

{ #category : #accessing }
UnrestPluggableEndpoint >> endpointPath [
	^ path
]

{ #category : #api }
UnrestPluggableEndpoint >> executeHttpMethod: aMethod [
	method := aMethod.
	^ unrest execute: self
]

{ #category : #api }
UnrestPluggableEndpoint >> get [
	^ self executeHttpMethod: #get
]

{ #category : #accessing }
UnrestPluggableEndpoint >> headers [
	^ headers
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initialize [
	super initialize.
	self initializeData.
	self initializeHeaders.
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initializeData [
	data := Dictionary new
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initializeHeaders [
	headers := Dictionary new
]

{ #category : #api }
UnrestPluggableEndpoint >> patch [
	^ self executeHttpMethod: #patch
]

{ #category : #accessing }
UnrestPluggableEndpoint >> path [
	^ path
]

{ #category : #accessing }
UnrestPluggableEndpoint >> path: anObject [
	path := anObject
]

{ #category : #api }
UnrestPluggableEndpoint >> post [
	^ self executeHttpMethod: #post
]

{ #category : #api }
UnrestPluggableEndpoint >> put [
	^ self executeHttpMethod: #put
]

{ #category : #data }
UnrestPluggableEndpoint >> resetData [
	self initializeData
]
