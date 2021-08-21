"
I am a pluggable endpoint that's primarily used for scripting interactions with web-based services. I provide an interface for configuring requests and implement common HTTP methods via #get, #post, #put, #patch and #delete.

Sending #/ message with a path argument to an instance of ==WSClient== or ==TWSEndpoint== will first look for a concrete endpoint class for the resulting path. If none could be found, my instance will be returned, capturing the final path.

I provide two ways of configuring http request: one via #httpConfiguration, and the other via parameterized executing methods (#get:, etc). The former tends to stick with my instances and is executed first. The latter is evaluated immediately before executing the configured HTTP request and is only used for that one request. The block argument will be passed an instance of ==ZnClient==.

I also implement a block-based enumeration via #enumeration:. When set, the block will be passed three arguments: 1) an instance of the endpoint 2) number of items requested and 3) pertinent cursor object (see ==TWSEnumeration== and ==TWSEnumerationCursor==).

[[[
			client := WSClient withUrl: 'http://example.com'.
			client httpConfiguration: [:http | 
				http contenWriter: [ :obj | ZnEntity json: (NeoJSONWriter toString: obj) ] ].
			
			""GET /examples""
			(client / #examples) get. 
			
			""PUT /examples {aNewExample asJson}""
			(client / #examples) put: [ :http | 
				http request contents: aNewExample
				].
			
			""Paginate the entirety of GET /examples?page=&page_size=""
			(client / #examples) 
				enumeration: [ :endpoint :limit :cursor |
					| result |
					""Return result of #get:, and update cursor""
					result := endpoint get: [ :http | 
						http 
							queryAt: #page put: (cursor at: #page ifAbsentPut: 1);
							queryAt: #page_size put: (cursor at: #page_size ifAbsentPut: 100)
						].
					cursor at: #page put: (cursor at: #page) + 1.
					cursor hasMore: result size = (cursor at: #page_size).
					result
					]; 
				collect: #yourself.
]]]

To explicitly create a pluggable endpoint:

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
		'method',
		'enumeration',
		'httpConfiguration',
		'wsClient'
	],
	#category : #'Ethel-Core'
}

{ #category : #configuring }
WSPluggableEndpoint >> configureDerivedEndpoint: anEndpoint [
	(anEndpoint respondsTo: #httpConfiguration:)
		ifTrue: [ anEndpoint httpConfiguration: self httpConfiguration ]
]

{ #category : #configuring }
WSPluggableEndpoint >> configureOn: http [
	http method: method asString asUppercase asSymbol.
	httpConfiguration ifNotNil: [ :val | val cull: http cull: self ]
]

{ #category : #accessing }
WSPluggableEndpoint >> cursor [
	^ WSPluggableCursor new
]

{ #category : #api }
WSPluggableEndpoint >> delete [
	method := #delete.
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> delete: aBlock [
	method := #delete.
	^ self execute: aBlock
]

{ #category : #accessing }
WSPluggableEndpoint >> endpointPath [
	^ path
]

{ #category : #accessing }
WSPluggableEndpoint >> enumeration [
	^ enumeration
]

{ #category : #accessing }
WSPluggableEndpoint >> enumeration: anObject [
	enumeration := anObject
]

{ #category : #api }
WSPluggableEndpoint >> get [
	method := #get.
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> get: aBlock [
	method := #get.
	^ self execute: aBlock
]

{ #category : #accessing }
WSPluggableEndpoint >> httpConfiguration [
	^ httpConfiguration
]

{ #category : #accessing }
WSPluggableEndpoint >> httpConfiguration: anObject [
	httpConfiguration := anObject
]

{ #category : #enumerating }
WSPluggableEndpoint >> next: aLimit with: aCursor [
	enumeration ifNil: [ ^ nil ].
	^ enumeration cull: self cull: aLimit cull: aCursor
]

{ #category : #api }
WSPluggableEndpoint >> patch [
	method := #patch.
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> patch: aBlock [
	method := #patch.
	^ self execute: aBlock
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
	method := #post.
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> post: aBlock [
	method := #post.
	^ self execute: aBlock
]

{ #category : #api }
WSPluggableEndpoint >> put [
	method := #put.
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> put: aBlock [
	method := #put.
	^ self execute: aBlock
]
