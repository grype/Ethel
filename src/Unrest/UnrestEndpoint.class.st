Class {
	#name : #UnrestEndpoint,
	#superclass : #Object,
	#instVars : [
		'client',
		'url',
		'data',
		'httpClient',
		'headers'
	],
	#category : #Unrest
}

{ #category : #'instance creation' }
UnrestEndpoint class >> urlOn: aClient [
	^ aClient baseUrl 
]

{ #category : #'instance creation' }
UnrestEndpoint class >> withClient: aClient [ 
	^ self basicNew initializeWithClient: aClient url: (self urlOn: aClient)
]

{ #category : #'instance creation' }
UnrestEndpoint class >> withClient: aClient url: aUrl [
	^ self basicNew initializeWithClient: aClient url: aUrl
]

{ #category : #endpoints }
UnrestEndpoint >> / aPath [
	"Creates a new generic endpoint by appending a new path."
	^ self class withClient: client url: self url / aPath
]

{ #category : #endpoints }
UnrestEndpoint >> // aPath [
	"Creates a new generic endpoint by appending a new path and preserving current data"

	^ (self class withClient: client url: self url / aPath)
		data: self data;
		yourself
]

{ #category : #endpoints }
UnrestEndpoint >> > endPointClass [
	"Creates a new endpoint of specified class."
	^ endPointClass withClient: self client
]

{ #category : #endpoints }
UnrestEndpoint >> >> endPointClass [
	"Creates a new endpoint of specified class, while retaining existing data"

	^ (endPointClass withClient: self client)
		data: self data;
		yourself
]

{ #category : #accessing }
UnrestEndpoint >> allowedHttpMethods [
	^ #(#head #get #post #put #patch #delete #trace)
]

{ #category : #data }
UnrestEndpoint >> at: aPropertyName put: aValue [
	data at: aPropertyName put: aValue
]

{ #category : #accessing }
UnrestEndpoint >> client [
	^ client
]

{ #category : #http }
UnrestEndpoint >> configureHttpClient [
	| http |
	self httpClient url: url.
	headers isEmptyOrNil
		ifTrue: [ ^ self ].

	http := self httpClient.
	headers associationsDo: [ :assoc | http headerAt: assoc key put: assoc value ]
]

{ #category : #accessing }
UnrestEndpoint >> data [
	^ data
]

{ #category : #accessing }
UnrestEndpoint >> data: anObject [
	data := anObject
]

{ #category : #'http requests' }
UnrestEndpoint >> delete [
	^ self perform: #delete dataInQuery: false
]

{ #category : #'http requests' }
UnrestEndpoint >> get [
	^ self perform: #get dataInQuery: true
]

{ #category : #accessing }
UnrestEndpoint >> headers [
	^ headers
]

{ #category : #accessing }
UnrestEndpoint >> headers: anObject [
	headers := anObject
]

{ #category : #accessing }
UnrestEndpoint >> httpClient [
	^ httpClient ifNil: [ httpClient := client createHttpClient ]
]

{ #category : #initialization }
UnrestEndpoint >> initializeData [
	data := Dictionary new
]

{ #category : #initialization }
UnrestEndpoint >> initializeWithClient: aClient url: aUrl [
	self initialize.
	client := aClient.
	url := aUrl asUrl.
	self initializeData
]

{ #category : #'http requests' }
UnrestEndpoint >> patch [
	^ self perform: #patch dataInQuery: false
]

{ #category : #'http requests' }
UnrestEndpoint >> perform: anHttpMethod dataInQuery: useQuery [
	| http result method |

	method := self validateHttpMethod: anHttpMethod.
	self configureHttpClient.
	http := self httpClient.
	self data
		ifNotNil: [ :d | 
			useQuery
				ifTrue: [ http queryAddAll: d ]
				ifFalse: [ http contents: d ] ].
	result := http perform: method.
	self validateHttpResponse: http response.
	^ result
]

{ #category : #'http requests' }
UnrestEndpoint >> post [
	^ self perform: #post dataInQuery: false
]

{ #category : #'http requests' }
UnrestEndpoint >> put [
	^ self perform: #put dataInQuery: false
]

{ #category : #data }
UnrestEndpoint >> remove: aPropertyName [
	data remove: aPropertyName ifAbsent: [  ]
]

{ #category : #data }
UnrestEndpoint >> resetData [
	self initializeData
]

{ #category : #accessing }
UnrestEndpoint >> url [
	^ url
]

{ #category : #http }
UnrestEndpoint >> validateHttpMethod: anHttpMethod [
	| method |
	method := anHttpMethod asLowercase.
	^ (self allowedHttpMethods includes: method)
		ifTrue: [ method asSymbol ]
		ifFalse:
			[ UnrestError signal: ('Tried to perform invalid HTTP Method "{1}"' format: {anHttpMethod}) ]
]

{ #category : #http }
UnrestEndpoint >> validateHttpResponse: aResponse [
	aResponse isSuccess
		ifTrue: [ ^ true ].
	UnrestError
		signal:
			('{1}: {2}'
				format:
					{aResponse statusLine code.
					aResponse statusLine reason})
]
