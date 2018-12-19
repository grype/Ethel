Class {
	#name : #UnrestEndpointTest,
	#superclass : #TestCase,
	#instVars : [
		'client',
		'endpoint'
	],
	#category : #'Unrest-Tests-Core'
}

{ #category : #running }
UnrestEndpointTest >> setUp [
	client := UnrestTestClient default.
	endpoint := UnrestTestEndpoint on: client.
]

{ #category : #tests }
UnrestEndpointTest >> stubHttp: aBlock [
	| http response |

	http := client createHttpClient.
	response := ZnResponse ok: (ZnEntity text: 'ok').
	http stub execute willReturn: [ http request ].
	http stub response willReturn: response.
	client stub createHttpClient willReturn: http.
	endpoint stub.
	aBlock cull: http cull: response
]

{ #category : #tests }
UnrestEndpointTest >> testEndpointComposition [
	| ep |

	ep := endpoint > UnrestAnotherTestEndpoint.
	self assert: ep class equals: UnrestAnotherTestEndpoint.
	self assert: ep unrest equals: endpoint unrest.
	self assert: ep endpointPath equals: UnrestAnotherTestEndpoint endpointPath.
	self assert: (ep headers keys includesAll: endpoint headers keys) description: 'Derived endpoint was not correctly conifgured'.
]

{ #category : #tests }
UnrestEndpointTest >> testHttpConfiguration [
	| http |
	endpoint stub.
	http := client createHttpClient.
	endpoint configureOn: http.
	self
		assert: (http request headers at: UnrestTestEndpoint testHeaderName ifAbsent: [ nil ])
		equals: UnrestTestEndpoint testHeaderValue
]

{ #category : #tests }
UnrestEndpointTest >> testHttpMethod [
	self
		stubHttp: [ :http :response | 
			client allowedHttpMethods
				do: [ :method | 
					endpoint perform: method.
					http request method asLowercase should equal: method asLowercase ] ]
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithAbsoluteMixedPathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getAbsoluteMixed: 'foo'.
			http request url should
				equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'mixed' / 'foo' / 'path') segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithAbsolutePathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getAbsoluteKeyword: 'foo'.
			http request url should equal: (client baseUrl addPathSegments: (Path / 'foo') segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithRelativeMixedPathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getRelativeMixed: 'foo'.
			http request url should
				equal:
					(client baseUrl
						addPathSegments: (endpoint endpointPath / 'relative' / 'mixed' / 'foo' / 'path') segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithRelativePathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getRelativeKeyword: 'foo'.
			http request url should equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'foo') segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testPluggableEndpointComposition [
	| ep |
	ep := endpoint / 'pluggable'.
	self assert: ep class equals: UnrestPluggableEndpoint.
	self assert: ep unrest equals: endpoint unrest.
	self assert: ep endpointPath equals: endpoint class endpointPath / 'pluggable'
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryExecution [
	self
		stubHttp: [ :http :response | 
			endpoint get.
			http request url should equal: (client baseUrl addPathSegments: endpoint endpointPath segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithAbsoluteDeepPathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getAbsoluteDeep.
			http request url should
				equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'deep' / 'path') segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithAbsolutePathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getAbsolute.
			http request url should equal: (client baseUrl addPathSegments: (Path / 'absolute') segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithRelativeDeepPathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getRelativeDeep.
			http request url should
				equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'deep' / 'path') segments) ]
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithRelativePathExecution [
	self
		stubHttp: [ :http :response | 
			endpoint getRelative.
			http request url should equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative') segments) ]
]
