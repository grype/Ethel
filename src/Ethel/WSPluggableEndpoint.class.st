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
	#traits : 'TWSEndpoint @ {#defaultConfigure->#configure} + TWSEnumeration + TWSPathEncoder',
	#classTraits : 'TWSEndpoint classTrait + TWSEnumeration classTrait + TWSPathEncoder classTrait',
	#instVars : [
		'path',
		'enumeration',
		'wsClient',
		'pathEncoder'
	],
	#category : #'Ethel-Core'
}

{ #category : #endpoints }
WSPluggableEndpoint >> / aStringOrEndpoint [
	| ep |

	ep := self wsClient / aStringOrEndpoint.
	ep isWSPluggableEndpoint ifTrue: [ ep path: (path resolve: ep path) ].
	^ ep
]

{ #category : #'building - transport' }
WSPluggableEndpoint >> configure [

	self defaultConfigure.
	WSCurrentContext value ifNotNil: [ :context | 
		(pathEncoder ifNil: [ self ]) encodePath: path on: context transport ]
]

{ #category : #accessing }
WSPluggableEndpoint >> cursor [
	^ WSPluggableCursor new
]

{ #category : #api }
WSPluggableEndpoint >> delete [
	<delete>
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> delete: aBlock [
	<delete>
	^ self execute: aBlock
]

{ #category : #private }
WSPluggableEndpoint >> encodePath: aPath on: aTransport [

	| newPath |
	newPath := aTransport basePath resolve: aPath.
	aTransport request url
		clearPath;
		addPathSegments: aPath segments
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
	<get>
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> get: aBlock [
	<get>
	^ self execute: aBlock
]

{ #category : #initialization }
WSPluggableEndpoint >> initialize [
	super initialize.
	path := Path * ''
]

{ #category : #testing }
WSPluggableEndpoint >> isWSPluggableEndpoint [
	^ true
]

{ #category : #enumerating }
WSPluggableEndpoint >> nextWith: aCursor [
	^ enumeration ifNotNil: [ :enumBlock | 
		  enumBlock cull: self cull: aCursor ]
]

{ #category : #api }
WSPluggableEndpoint >> patch [
	<patch>
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> patch: aBlock [
	<patch>
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
	<post>
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> post: aBlock [
	<post>
	^ self execute: aBlock
]

{ #category : #api }
WSPluggableEndpoint >> put [
	<put>
	^ self execute
]

{ #category : #api }
WSPluggableEndpoint >> put: aBlock [
	<put>
	^ self execute: aBlock
]

{ #category : #resolving }
WSPluggableEndpoint >> resolve: aPathOrString [

	path := (path ifNil: [ wsClient basePath ]) resolve: (aPathOrString isString
			         ifTrue: [ Path * aPathOrString ]
			         ifFalse: [ aPathOrString ])
]
