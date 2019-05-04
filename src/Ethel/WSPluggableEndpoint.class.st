"
I am a pluggable endpoint primarily used for scripting interactions with a web-based service. Both ==WSClient== and ==TWSEndpoint== create instances of me via #/ method. I provide an interface for configuring request headers and request data, and implement common HTTP methods like #get, #post, #put, #patch and #delete.

Sending #/ message with a path argument to an instance of ==WSClient== or ==TWSEndpoing== will first look for a concrete endpoint class for that path. If none could be found, my instance instance will be returned, capturing the final path.

I also implement a block-based enumeration via #enumerationBlock. When set, the block will be passed three arguments: 1) an instance of the endpoint b) number of items requested and c) pertinent cursor object (see ==TWSEnumeration== and ==TWSEnumerationCursor==).

[[[
			client := WSClient withUrl: 'http://example.com'.
			client contentWriter: [ :obj | ZnEntity json: obj asJson ].
			(client / #examples) get. ""GET /examples""
			(client / #examples) data: aNewExample; put. ""PUT /examples {aNewExample asJson}""
			(client / #examples) 
				enumerationBlock: [ :endpoint :limit :cursor | 
					endpoint data at: #page put: (cursor at: #page).
					endpoint data at: #page_size put: (cursor at: #pageSize) ]; 
				collect: #yourself.
]]]

To explicitly create a pluggable instance:

[[[
			client := WSClient withUrl: 'http://example.com'.
			(client / WSPluggableEndpoint) path: Path / #examples; get.
]]]
"
Class {
	#name : #WSPluggableEndpoint,
	#superclass : #Object,
	#traits : 'TWSEndpoint + TWSEnumeration',
	#classTraits : 'TWSEndpoint classTrait + TWSEnumeration classTrait',
	#instVars : [
		'path',
		'data',
		'method',
		'headers',
		'enumerationBlock'
	],
	#category : #'Ethel-Core'
}

{ #category : #configuring }
WSPluggableEndpoint >> configureDerivedEndpoint: anEndpoint [
	headers isEmptyOrNil
		ifFalse: [ anEndpoint headersAddAll: headers associations ]
]

{ #category : #configuring }
WSPluggableEndpoint >> configureOn: http [
	data
		ifNotNil: [ :aData | 
			method = #get
				ifTrue: [ http queryAddAll: aData ]
				ifFalse: [ http contents: aData ] ].

	http method: method asString asUppercase asSymbol.
	http headerAddAll: headers
]

{ #category : #accessing }
WSPluggableEndpoint >> cursor [
	^ WSPluggableCursor new
]

{ #category : #accessing }
WSPluggableEndpoint >> data [
	^ data
]

{ #category : #accessing }
WSPluggableEndpoint >> data: anObject [
	data := anObject
]

{ #category : #api }
WSPluggableEndpoint >> delete [
	^ self executeHttpMethod: #delete
]

{ #category : #accessing }
WSPluggableEndpoint >> endpointPath [
	^ path
]

{ #category : #accessing }
WSPluggableEndpoint >> enumerationBlock [
	^ enumerationBlock
]

{ #category : #accessing }
WSPluggableEndpoint >> enumerationBlock: anObject [
	enumerationBlock := anObject
]

{ #category : #api }
WSPluggableEndpoint >> executeHttpMethod: aMethod [
	method := aMethod.
	^ wsClient execute: self
]

{ #category : #executing }
WSPluggableEndpoint >> executingContext [
	| sender |

	sender := thisContext sender.
	[ sender isNotNil and: [ sender method isWSEndpointExecutionMethod not ] ]
		whileTrue: [ sender := sender sender ].

	^ sender
]

{ #category : #api }
WSPluggableEndpoint >> get [
	^ self executeHttpMethod: #get
]

{ #category : #headers }
WSPluggableEndpoint >> headerAt: aPropertyName put: aValue [
	headers at: aPropertyName put: aValue
]

{ #category : #accessing }
WSPluggableEndpoint >> headers [
	^ headers
]

{ #category : #headers }
WSPluggableEndpoint >> headersAddAll: aKeyedCollection [
	headers addAll: aKeyedCollection 
]

{ #category : #headers }
WSPluggableEndpoint >> headersRemoveAll [
	headers removeAll
]

{ #category : #headers }
WSPluggableEndpoint >> headersRemoveAt: aName [
	headers remove: aName ifAbsent: [  ]
]

{ #category : #initialization }
WSPluggableEndpoint >> initialize [
	super initialize.
	self initializeHeaders.
]

{ #category : #initialization }
WSPluggableEndpoint >> initializeHeaders [
	headers := Dictionary new
]

{ #category : #enumerating }
WSPluggableEndpoint >> next: aLimit with: aCursor [
	enumerationBlock ifNil: [ ^ nil ].
	^ enumerationBlock cull: self cull: aCursor cull: aLimit
]

{ #category : #api }
WSPluggableEndpoint >> patch [
	^ self executeHttpMethod: #patch
]

{ #category : #accessing }
WSPluggableEndpoint >> path [
	^ path
]

{ #category : #accessing }
WSPluggableEndpoint >> path: anObject [
	path := anObject
]

{ #category : #api }
WSPluggableEndpoint >> post [
	^ self executeHttpMethod: #post
]

{ #category : #api }
WSPluggableEndpoint >> put [
	^ self executeHttpMethod: #put
]
