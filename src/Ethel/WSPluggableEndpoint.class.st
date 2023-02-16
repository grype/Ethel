"
I am a pluggable endpoint that's primarily used for scripting interactions with web-based services. 

I work in tandem with `WSDynamicClient` and provide an interface for executing requests via #get, #post, #put, #patch and #delete methods, which reflect the HTTP method they utilize.

## Deriving endpoints

Sending #/ message with a path argument to me or the `WSClient` will create a new instance of me capturing the argument as its path. When deriving pluggable endpoints this way, the path accumulates - i.e. client / #foo / #bar will produce an instance with a relative path of 'foo/bar'. The path argument can be a symbol, string or a Path object.

## Example

Here's a typical example of what I can do:

```
client := 'http://example.com/api' asWebClient.
(client / #foo / #bar) get.  ""GET /api/foo/bar""
```

You can pass a block to the executing methods if you need to configure the request further:

```
(client / #foo / #bar) get: [:http | http request queryAt: #baz put: #baaz ]. ""GET /api/foo/bar?baz=baaz""
```

Similarly, when POSTing data:

```
(client / #foo / #bar) post: [:http | http request content: someObject ].
```

## Path encoding

My instances are typically distinguished by their paths. When I execute a request, I resolve my path onto the client's base path. Not all APIs work this way, and the path - being a unique identifier for a logical endpoint - may need to be encoded differently - maybe in a header or a query parameter, or maybe even part of the JSON payload.

The behavior for encoding my paths onto the request is defined in the `TWSPathEncoder` trait. I use that trait to provide the default implementation of resolving the path as a path. You can supply a different object via #pathEncoder:.

## Enumeration

I implement a block-based enumeration via #onNext:. Pass a block that accepts two arguments: 1) the endpoint instance and 2) the cursor (see `TWSEnumeration` and `TWSEnumerationCursor`). The cursor will be an instance of `WSPluggableCursor`, which acts like a dictionary with a very limited API. The block would need to perform a request, advance the cursor and return the result. In this case the result is a slice of the larger collection of some objects that the endpoint iterates over. For example:

```
(client / #examples) 
	onNext: [ :endpoint :cursor |
		| result |
		""Return result of #get:, and update cursor""
		result := endpoint get: [ :http | 
			http 
				queryAt: #page put: (cursor at: #page ifAbsentPut: 1);
				queryAt: #page_size put: (cursor at: #page_size ifAbsentPut: 100) ].
		cursor at: #page put: (cursor at: #page) + 1.
		cursor hasMore: result size = (cursor at: #page_size).
		result]; 
	collect: #yourself.
```

Calling #collect will result in calling #nextWith:. which in turn will evaluate the block passed to #onNext. In this example, the block executes a GET request, adding some paginating query params, then advances the cursor by incrementing the page value and indicating whether there are more results, and finally returns the result. As you iterate over the elements using the familiar Collections API, this block gets called for as long as the cursor responds truthfully to #hasMore.

"
Class {
	#name : #WSPluggableEndpoint,
	#superclass : #Object,
	#traits : 'TWSEndpoint @ {#defaultConfigure->#configure} + TWSEnumeration + TWSPathEncoder',
	#classTraits : 'TWSEndpoint classTrait + TWSEnumeration classTrait + TWSPathEncoder classTrait',
	#instVars : [
		'path',
		'wsClient',
		'pathEncoder',
		'enumerationBlock'
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
	^ enumerationBlock ifNotNil: [ :enumBlock | 
		  enumBlock cull: self cull: aCursor ]
]

{ #category : #accessing }
WSPluggableEndpoint >> onNext [

	^ enumerationBlock
]

{ #category : #accessing }
WSPluggableEndpoint >> onNext: anObject [
	enumerationBlock := anObject
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

{ #category : #accessing }
WSPluggableEndpoint >> pathEncoder [

	^ pathEncoder
]

{ #category : #accessing }
WSPluggableEndpoint >> pathEncoder: anObject [

	pathEncoder := anObject
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
