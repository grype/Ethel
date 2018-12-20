Class {
	#name : #UnrestEndpointTest,
	#superclass : #TestCase,
	#instVars : [
		'client',
		'endpoint'
	],
	#category : #'Unrest-Tests-Core'
}

{ #category : #'tests-accessing' }
UnrestEndpointTest >> okJsonResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity json: aValue asJson)
]

{ #category : #'tests-accessing' }
UnrestEndpointTest >> okResponse [
	^ ZnResponse ok: (ZnEntity text: 'ok')
]

{ #category : #'tests-accessing' }
UnrestEndpointTest >> okResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity with: aValue)
]

{ #category : #running }
UnrestEndpointTest >> setUp [
	client := UnrestTestClient default.
	endpoint := UnrestTestEndpoint on: client.
]

{ #category : #'tests-accessing' }
UnrestEndpointTest >> stubHttp: http withResponse: aResponse [
	http stub execute willReturn: aResponse.
	http stub response willReturn: aResponse
]

{ #category : #'tests-accessing' }
UnrestEndpointTest >> stubbedCursor [
	| cursor |
	cursor := endpoint cursor.
	endpoint stub cursor willReturn: cursor.
	^ cursor
]

{ #category : #'tests-accessing' }
UnrestEndpointTest >> stubbedHttp [
	^ self stubbedHttpWithResponse: nil
]

{ #category : #'error handling' }
UnrestEndpointTest >> stubbedHttpWithResponse: aResponse [
	| http |

	http := client createHttpClient.
	aResponse ifNotNil: [ :val | self stubHttp: http withResponse: val ].

	client stub createHttpClient willReturn: http.
	^ http
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
UnrestEndpointTest >> testEnumerationDo [
	| expectedResult cursor http result |

	endpoint := client another.
	cursor := self stubbedCursor.
	expectedResult := (endpoint offset to: cursor total - 1) asOrderedCollection.
	http := self
		stubbedHttpWithResponse: (self okResponseWith: [ (endpoint offset to: (cursor total min: endpoint offset + endpoint limit) - 1) asArray ]).
	result := OrderedCollection new.

	endpoint offset should be: 0.
	endpoint do: [ :responseResult | result add: responseResult ].
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor total.
	expectedResult should equal: result
]

{ #category : #tests }
UnrestEndpointTest >> testEnumerationNext [
	| expectedResult cursor http |

	endpoint := client another.
	cursor := self stubbedCursor.
	expectedResult := (endpoint offset to: (cursor total min: endpoint offset + endpoint limit) - 1) asArray.
	http := self stubbedHttpWithResponse: (self okJsonResponseWith: expectedResult).

	endpoint offset should be: 0.
	endpoint next: [ :responseResult | responseResult should equal: expectedResult ].
	cursor offset should be: endpoint limit.
	http should receive execute
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
	| http |

	http := self stubbedHttpWithResponse: self okResponse.
	client allowedHttpMethods
		do: [ :method | 
			endpoint perform: method.
			http request method asLowercase should equal: method asLowercase ]
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithAbsoluteMixedPathExecution [
	| http |

	http := self stubbedHttpWithResponse: self okResponse.

	endpoint getAbsoluteMixed: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithAbsolutePathExecution [
	| http |
	http := self stubbedHttpWithResponse: self okResponse.
	endpoint getAbsoluteKeyword: 'foo'.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'foo') segments)
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithRelativeMixedPathExecution [
	| http |
	http := self stubbedHttpWithResponse: self okResponse.

	endpoint getRelativeMixed: 'foo'.
	http request url should
		equal:
			(client baseUrl
				addPathSegments: (endpoint endpointPath / 'relative' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #tests }
UnrestEndpointTest >> testKeywordWithRelativePathExecution [
	| http |
	http := self stubbedHttpWithResponse: self okResponse.

	endpoint getRelativeKeyword: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'foo') segments)
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
	| http |
	http := self stubbedHttpWithResponse: self okResponse.

	endpoint get.
	http request url should equal: (client baseUrl addPathSegments: endpoint endpointPath segments)
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithAbsoluteDeepPathExecution [
	| http |

	http := self stubbedHttpWithResponse: self okResponse.

	endpoint getAbsoluteDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'deep' / 'path') segments)
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithAbsolutePathExecution [
	| http |

	http := self stubbedHttpWithResponse: self okResponse.

	endpoint getAbsolute.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'absolute') segments)
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithRelativeDeepPathExecution [
	| http |

	http := self stubbedHttpWithResponse: self okResponse.

	endpoint getRelativeDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'deep' / 'path') segments)
]

{ #category : #tests }
UnrestEndpointTest >> testUnaryWithRelativePathExecution [
	| http |

	http := self stubbedHttpWithResponse: self okResponse.

	endpoint getRelative.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative') segments)
]
