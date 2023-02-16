"
I am a dynamic implementation of the `WSClient`.

`WSClient` by itself isn't very useful and is expected to be subclassed. I am such a subclass that provides general-purpose API for  configuration and executing requests. I am intended to be used for adhoc queries. If you're attempting to work with a web-based API - consider subclassing `WSClient` instead.

I work in tandem with `WSPluggableEndpoint`s. Typically you would derive pluggable endpoints from me and call appropriate request methods on the ednpoints to initiate the request.

For example:

```
example := 'https://example.com/api' asWebClient
	queryAt: #api_key put: 'abcd';
	yourself.
	
(example / #path / #somewhere) get.
```

Quickly create an instance of me from a url by calling #asWebClient on either a URL string or an instance of `ZnUrl`. For configuring behavior that's common to all endpoints - call methods in #configuring category. In the example above, the client will configure every request by adding 'api_key' query param.

To initiate requests - derive an endpoint by sending a symbol to #/ - I will return an instance of `WSPluggableEndpoint` that will be configured by resolving the passed symbol against my `baseUrl`. In the above example we're ultimately deriving an endpoint with a relative path of: 'path/somewhere'. At the time of request, the final URL will be: 'https://example.com/api/path/somewhere'. You can control whether or not the endpoint path will be resolved at the time of request by sending a boolean value to the endpoint's #ignoresPath: method.

See comment on `WSPluggableEndpoint` for more info.

## Notes on transport configuration

I maintain a list of transport builders - objects whose classes use `TWSTransportBuilder`. During request execution, I will ask those builders to apply themselves via the intermediate visitor object, whose class is returned by the class-side method #transportVisitorClass.

You can extend my configuration repertoire by defining additional builder classes and adding their instances via #addTransportBuilder:
"
Class {
	#name : #WSDynamicClient,
	#superclass : #WSClient,
	#instVars : [
		'transportBuilders',
		'baseUrl'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
WSDynamicClient class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #building }
WSDynamicClient >> addTransportBuilder: aBuilder [
	transportBuilders add: aBuilder
]

{ #category : #accessing }
WSDynamicClient >> baseUrl [
	^ self shouldBeImplemented
]

{ #category : #enumerating }
WSDynamicClient >> beforeRequestDo: aBlock [
	self addTransportBuilder: (WSContextBuilder with: aBlock)
]

{ #category : #configuring }
WSDynamicClient >> configure [
	| visitor |

	super configure.
	visitor := WSZincTransportVisitor new.
	transportBuilders do: [ :aBuilder | aBuilder accept: visitor ]
]

{ #category : #building }
WSDynamicClient >> expectJsonContent [
	self addTransportBuilder: WSJsonContentBuilder new
]

{ #category : #building }
WSDynamicClient >> headerAt: aHeader add: aValue [
	self addTransportBuilder: (WSRequestHeaderBuilder new
			 headerKey: aHeader;
			 headerValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #building }
WSDynamicClient >> headerAt: aHeader put: aValue [
	self addTransportBuilder: (WSRequestHeaderBuilder new
			 headerKey: aHeader;
			 headerValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #initialization }
WSDynamicClient >> initialize [
	super initialize.
	transportBuilders := OrderedCollection new
]

{ #category : #initialization }
WSDynamicClient >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]

{ #category : #building }
WSDynamicClient >> queryAt: aHeader add: aValue [
	self addTransportBuilder: (WSRequestQueryBuilder new
			 queryKey: aHeader;
			 queryValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #building }
WSDynamicClient >> queryAt: aHeader put: aValue [
	self addTransportBuilder: (WSRequestQueryBuilder new
			 queryKey: aHeader;
			 queryValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #building }
WSDynamicClient >> readContents: aBlock [
	self addTransportBuilder: (WSContentBuilder new reader: aBlock)
]

{ #category : #building }
WSDynamicClient >> writeContents: aBlock [
	self addTransportBuilder: (WSContentBuilder new writer: aBlock)
]
