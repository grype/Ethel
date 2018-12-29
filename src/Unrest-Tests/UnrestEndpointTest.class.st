Class {
	#name : #UnrestEndpointTest,
	#superclass : #TestCase,
	#instVars : [
		'client',
		'endpoint',
		'cursor',
		'http'
	],
	#category : #'Unrest-Tests-Core'
}

{ #category : #stubbing }
UnrestEndpointTest >> okJsonResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity json: aValue asJson)
]

{ #category : #stubbing }
UnrestEndpointTest >> okResponse [
	^ ZnResponse ok: (ZnEntity text: 'ok')
]

{ #category : #stubbing }
UnrestEndpointTest >> okResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity with: aValue)
]

{ #category : #running }
UnrestEndpointTest >> setUp [
	client := UnrestTestClient default.
	endpoint := UnrestTestEndpoint on: client.
]

{ #category : #stubbing }
UnrestEndpointTest >> stubForEnumeration [
	endpoint := client another.
	cursor := self stubbedCursor.
	http := self
		stubbedHttpWithResponse: (self okResponseWith: [ (endpoint offset to: (cursor total min: endpoint offset + endpoint limit) - 1) asArray ])
]

{ #category : #stubbing }
UnrestEndpointTest >> stubForExecution [
	http := self stubbedHttpWithResponse: self okResponse
]

{ #category : #stubbing }
UnrestEndpointTest >> stubHttp: http withResponse: aResponse [
	http stub execute willReturn: aResponse.
	http stub response willReturn: aResponse
]

{ #category : #stubbing }
UnrestEndpointTest >> stubbedCursor [
	| cursor |
	cursor := endpoint cursor.
	endpoint stub cursor willReturn: cursor.
	^ cursor
]

{ #category : #stubbing }
UnrestEndpointTest >> stubbedHttp [
	^ self stubbedHttpWithResponse: nil
]

{ #category : #stubbing }
UnrestEndpointTest >> stubbedHttpWithResponse: aResponse [
	| http |

	http := client createHttpClient.
	aResponse ifNotNil: [ :val | self stubHttp: http withResponse: val ].

	client stub createHttpClient willReturn: http.
	^ http
]

{ #category : #'tests-composing' }
UnrestEndpointTest >> testEndpointComposition [
	| ep |

	ep := endpoint > UnrestAnotherTestEndpoint.
	self assert: ep class equals: UnrestAnotherTestEndpoint.
	self assert: ep unrest equals: endpoint unrest.
	self assert: ep endpointPath equals: UnrestAnotherTestEndpoint endpointPath.
	self assert: (ep headers keys includesAll: endpoint headers keys) description: 'Derived endpoint was not correctly conifgured'.
]

{ #category : #'tests-enumerating' }
UnrestEndpointTest >> testEnumerationDetect [
	| expectedResult result |

	self stubForEnumeration.
	expectedResult := 1.

	endpoint offset should be: 0.
	result := endpoint detect: [ :responseResult | responseResult odd ].
	http should receive execute exactly: 1.
	cursor offset should equal: cursor offset.
	result should equal: expectedResult
]

{ #category : #'tests-enumerating' }
UnrestEndpointTest >> testEnumerationDetectNotFound [
	| result |

	self stubForEnumeration.

	endpoint offset should be: 0.
	result := endpoint detect: [ :responseResult | responseResult > cursor total ] ifNone: [ nil ].
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor offset.
	result should be: nil
]

{ #category : #'tests-enumerating' }
UnrestEndpointTest >> testEnumerationDetectRaiseNotFound [
	self stubForEnumeration.
	endpoint offset should be: 0.
	[ endpoint detect: [ :responseResult | responseResult > cursor total ] ] should raise: NotFound.
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor offset
]

{ #category : #'tests-enumerating' }
UnrestEndpointTest >> testEnumerationDo [
	| expectedResult result |

	self stubForEnumeration.
	expectedResult := (endpoint offset to: cursor total - 1) asOrderedCollection.
	result := OrderedCollection new.

	endpoint offset should be: 0.
	endpoint do: [ :responseResult | result add: responseResult ].
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor total.
	result should equal: expectedResult
]

{ #category : #'tests-enumerating' }
UnrestEndpointTest >> testEnumerationFirst [
	self stubForEnumeration.
	endpoint offset should be: 0.
	endpoint first should equal: 0.
	cursor offset should be: endpoint limit.
	http should receive execute
]

{ #category : #'tests-enumerating' }
UnrestEndpointTest >> testEnumerationNext [
	| expectedResult |

	self stubForEnumeration.
	expectedResult := (endpoint offset to: (cursor total min: endpoint offset + endpoint limit) - 1)
		asArray.

	endpoint offset should be: 0.
	(endpoint next: endpoint cursor) should equal: expectedResult.
	cursor offset should be: endpoint limit.
	http should receive execute
]

{ #category : #'tests-enumerating' }
UnrestEndpointTest >> testEnumerationSelect [
	| expectedResult result |

	self stubForEnumeration.
	expectedResult := ((endpoint offset to: cursor total - 1) select: #odd) asOrderedCollection.

	endpoint offset should be: 0.
	result := endpoint select: [ :responseResult | responseResult odd ].
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor offset.
	result should equal: expectedResult
]

{ #category : #'tests-configuring' }
UnrestEndpointTest >> testHttpConfiguration [
	| http |
	endpoint stub.
	http := client createHttpClient.
	endpoint configureOn: http.
	self
		assert: (http request headers at: UnrestTestEndpoint testHeaderName ifAbsent: [ nil ])
		equals: UnrestTestEndpoint testHeaderValue
]

{ #category : #'tests-configuring' }
UnrestEndpointTest >> testHttpMethod [
	| http |

	http := self stubbedHttpWithResponse: self okResponse.
	client allowedHttpMethods
		do: [ :method | 
			endpoint perform: method.
			http request method asLowercase should equal: method asLowercase ]
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testKeywordWithAbsoluteMixedPathExecution [
	self stubForExecution.
	endpoint getAbsoluteMixed: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testKeywordWithAbsolutePathExecution [
	self stubForExecution.
	endpoint getAbsoluteKeyword: 'foo'.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'foo') segments)
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testKeywordWithRelativeMixedPathExecution [
	self stubForExecution.
	endpoint getRelativeMixed: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testKeywordWithRelativePathExecution [
	self stubForExecution.
	endpoint getRelativeKeyword: 'foo'.
	http request url should equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'foo') segments)
]

{ #category : #'tests-composing' }
UnrestEndpointTest >> testPluggableEndpointComposition [
	| ep |
	ep := endpoint / 'pluggable'.
	self assert: ep class equals: UnrestPluggableEndpoint.
	self assert: ep unrest equals: endpoint unrest.
	self assert: ep endpointPath equals: endpoint class endpointPath / 'pluggable'
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testUnaryExecution [
	self stubForExecution.
	endpoint get.
	http request url should equal: (client baseUrl addPathSegments: endpoint endpointPath segments)
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testUnaryWithAbsoluteDeepPathExecution [
	self stubForExecution.
	endpoint getAbsoluteDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'deep' / 'path') segments)
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testUnaryWithAbsolutePathExecution [
	self stubForExecution.
	endpoint getAbsolute.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'absolute') segments)
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testUnaryWithRelativeDeepPathExecution [
	self stubForExecution.
	endpoint getRelativeDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'deep' / 'path') segments)
]

{ #category : #'tests-executing' }
UnrestEndpointTest >> testUnaryWithRelativePathExecution [
	self stubForExecution.
	endpoint getRelative.
	http request url should
		equal:
			(client baseUrl
				addPathSegments: (endpoint endpointPath / 'relative') segments)
]
