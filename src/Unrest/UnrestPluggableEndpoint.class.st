Class {
	#name : #UnrestPluggableEndpoint,
	#superclass : #UnrestEndpoint,
	#instVars : [
		'path',
		'data',
		'method'
	],
	#category : #Unrest
}

{ #category : #configuring }
UnrestPluggableEndpoint >> configureOn: http [
	super configureOn: http.
	method = #get
		ifTrue: [ http queryAddAll: data ]
		ifFalse: [ http contents: data ].
	http method: method
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
	^ self perform: #delete
]

{ #category : #accessing }
UnrestPluggableEndpoint >> endpointPath [
	^ path
]

{ #category : #api }
UnrestPluggableEndpoint >> get [
	^ self perform: #get
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initialize [
	super initialize.
	self initializeData 
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initializeData [
	data := Dictionary new
]

{ #category : #api }
UnrestPluggableEndpoint >> patch [
	^ self perform: #patch
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
UnrestPluggableEndpoint >> perform: aMethod [
	method := aMethod.
	^ unrest execute: self
]

{ #category : #api }
UnrestPluggableEndpoint >> post [
	^ self perform: #post
]

{ #category : #api }
UnrestPluggableEndpoint >> put [
	^ self perform: #put
]

{ #category : #data }
UnrestPluggableEndpoint >> resetData [
	self initializeData
]
