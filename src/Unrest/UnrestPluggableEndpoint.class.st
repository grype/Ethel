"
I am a pluggable endpoint primarily used for scripting interactions with a web-based service. Both ==Unrest== and ==TUnrestEndpoint== create instances of me via #/ method. I provide flexible interface for configuring request headers and data and implement common HTTP methods like GET, POST, PUT, PATCH and DELETE.

From any client or endpoint, simply send #/ with a path argument. The newly created instance of me will capture the resulting path: 

client := Unrest withUrl: 'http://example.com'.
client contentWriter: [ :obj | ZnEntity json: obj asJson ].
(client / #examples) get. ""GET /examples""
(client / #examples) data: aNewExample; put. ""PUT {aNewExample asJson}""
"
Class {
	#name : #UnrestPluggableEndpoint,
	#superclass : #Object,
	#traits : 'TUnrestEndpoint',
	#classTraits : 'TUnrestEndpoint classTrait',
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
	headers isEmptyOrNil
		ifFalse: [ anEndpoint headersAddAll: headers associations ]
]

{ #category : #configuring }
UnrestPluggableEndpoint >> configureOn: http [
	data
		ifNotNil: [ :aData | 
			method = #get
				ifTrue: [ http queryAddAll: aData ]
				ifFalse: [ http contents: aData ] ].

	http method: method greaseString asUppercase asSymbol.
	http headerAddAll: headers
]

{ #category : #accessing }
UnrestPluggableEndpoint >> data [
	^ data
]

{ #category : #accessing }
UnrestPluggableEndpoint >> data: anObject [
	data := anObject
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

{ #category : #headers }
UnrestPluggableEndpoint >> headerAt: aPropertyName put: aValue [
	headers at: aPropertyName put: aValue
]

{ #category : #accessing }
UnrestPluggableEndpoint >> headers [
	^ headers
]

{ #category : #headers }
UnrestPluggableEndpoint >> headersAddAll: aKeyedCollection [
	headers addAll: aKeyedCollection 
]

{ #category : #headers }
UnrestPluggableEndpoint >> headersRemoveAll [
	headers removeAll
]

{ #category : #headers }
UnrestPluggableEndpoint >> headersRemoveAt: aName [
	headers remove: aName ifAbsent: [  ]
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initialize [
	super initialize.
	self initializeHeaders.
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
