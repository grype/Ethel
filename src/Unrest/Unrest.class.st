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

{ #category : #'instance creation' }
Unrest class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #endpoints }
Unrest >> / aString [
	"Creates a new generic endpoint."
	^ (UnrestPluggableEndpoint on: self) path: (Path / aString); yourself
]

{ #category : #endpoints }
Unrest >> > endPointClass [
	"Creates a new endpoint of specified class."
	^ endPointClass on: self
]

{ #category : #http }
Unrest >> allowedHttpMethods [
	^ #(#get #post #put #patch #delete #options)
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

{ #category : #http }
Unrest >> delete [
	^ self perform: #delete dataInQuery: false
]

{ #category : #http }
Unrest >> get [
	^ self perform: #get dataInQuery: true
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

{ #category : #http }
Unrest >> patch [
	^ self perform: #patch dataInQuery: false
]

{ #category : #http }
Unrest >> perform: aMethod dataInQuery: useQuery [
	| http result method sendData |

	self validateMethod: aMethod.
	self configureHttpClient.
	http := self httpClient.
	sendData := self data.
	sendData isEmptyOrNil ifFalse: [
			useQuery
				ifTrue: [ http queryAddAll: sendData ]
				ifFalse: [ http contents: sendData ] ].
	result := http perform: method.
	self validateResponse: http response.
	^ result
]

{ #category : #http }
Unrest >> post [
	^ self perform: #post dataInQuery: false
]

{ #category : #http }
Unrest >> put [
	^ self perform: #put dataInQuery: false
]

{ #category : #http }
Unrest >> validateMethod: aMethod [
	| method |
	method := aMethod asLowercase.
	^ (self allowedHttpMethods includes: method)
		ifTrue: [ method asSymbol ]
		ifFalse:
			[ UnrestError signal: ('Tried to perform invalid Method "{1}"' format: {aMethod}) ]
]

{ #category : #http }
Unrest >> validateResponse: aResponse [
	aResponse isSuccess
		ifTrue: [ ^ true ].
	UnrestError
		signal:
			('{1}: {2}'
				format:
					{aResponse statusLine code.
					aResponse statusLine reason})
]
