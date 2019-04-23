Class {
	#name : #WSEndpointTest,
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
WSEndpointTest >> okJsonResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity json: aValue asJson)
]

{ #category : #stubbing }
WSEndpointTest >> okResponse [
	^ ZnResponse ok: (ZnEntity text: 'ok')
]

{ #category : #stubbing }
WSEndpointTest >> okResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity with: aValue)
]

{ #category : #running }
WSEndpointTest >> setUp [
	client := WSTestClient default.
	endpoint := WSTestEndpoint on: client.
]

{ #category : #stubbing }
WSEndpointTest >> stubForEnumeration [
	endpoint := client collection.
	cursor := self stubbedCursor.
	http := self
		stubbedHttpWithResponse:
			(self
				okResponseWith: [ (endpoint offset to: (cursor total min: endpoint offset + endpoint limit) - 1) asArray ])
]

{ #category : #stubbing }
WSEndpointTest >> stubForExecution [
	http := self stubbedHttpWithResponse: self okResponse
]

{ #category : #stubbing }
WSEndpointTest >> stubHttp: http withResponse: aResponse [
	http stub execute willReturn: aResponse.
	http stub response willReturn: aResponse
]

{ #category : #stubbing }
WSEndpointTest >> stubbedCursor [
	| aCursor |
	aCursor := endpoint cursor.
	endpoint stub cursor willReturn: aCursor.
	^ aCursor
]

{ #category : #stubbing }
WSEndpointTest >> stubbedHttp [
	^ self stubbedHttpWithResponse: nil
]

{ #category : #stubbing }
WSEndpointTest >> stubbedHttpWithResponse: aResponse [
	| http |

	http := client createHttpClient.
	aResponse ifNotNil: [ :val | self stubHttp: http withResponse: val ].

	client stub createHttpClient willReturn: http.
	^ http
]

{ #category : #'tests-composing' }
WSEndpointTest >> testAbstractEndpoint [
	WSAbstractTestEndpoint isAbstractEndpoint should be.
	WSTestEndpoint isAbstractEndpoint should not be
]

{ #category : #'tests-composing' }
WSEndpointTest >> testEndpointComposition [
	| ep |

	ep := endpoint > WSCollectionTestEndpoint.
	ep class should equal: WSCollectionTestEndpoint.
	ep wsClient should equal: endpoint wsClient.
	ep endpointPath should equal: WSCollectionTestEndpoint endpointPath.
	(ep headers keys includesAll: endpoint headers keys) should be
]

{ #category : #'tests-enumerating' }
WSEndpointTest >> testEnumerationDetect [
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
WSEndpointTest >> testEnumerationDetectNotFound [
	| result |

	self stubForEnumeration.

	endpoint offset should be: 0.
	result := endpoint detect: [ :responseResult | responseResult > cursor total ] ifNone: [ nil ].
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor offset.
	result should be: nil
]

{ #category : #'tests-enumerating' }
WSEndpointTest >> testEnumerationDetectRaiseNotFound [
	self stubForEnumeration.
	endpoint offset should be: 0.
	[ endpoint detect: [ :responseResult | responseResult > cursor total ] ] should raise: NotFound.
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor offset
]

{ #category : #'tests-enumerating' }
WSEndpointTest >> testEnumerationDo [
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
WSEndpointTest >> testEnumerationFirst [
	self stubForEnumeration.
	endpoint offset should be: 0.
	endpoint first should equal: 0.
	cursor offset should be: endpoint limit.
	http should receive execute
]

{ #category : #'tests-enumerating' }
WSEndpointTest >> testEnumerationNext [
	| expectedResult |

	self stubForEnumeration.
	expectedResult := (endpoint offset to: (cursor total min: endpoint offset + endpoint limit) - 1)
		asArray.

	endpoint offset should be: 0.
	(endpoint nextWith: endpoint cursor) should equal: expectedResult.
	cursor offset should be: endpoint limit.
	http should receive execute
]

{ #category : #'tests-enumerating' }
WSEndpointTest >> testEnumerationSelect [
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
WSEndpointTest >> testHttpConfiguration [
	endpoint stub.
	http := client createHttpClient.
	endpoint configureOn: http.
	http request headers should
		include: WSTestEndpoint testHeaderValue
		at: WSTestEndpoint testHeaderName
]

{ #category : #'tests-configuring' }
WSEndpointTest >> testHttpMethod [
	| stubbedHttp |

	stubbedHttp := self stubbedHttpWithResponse: self okResponse.
	client class supportedHttpMethods
		do: [ :method | 
			endpoint perform: method.
			stubbedHttp request method asLowercase should equal: method asLowercase ]
]

{ #category : #'tests-other' }
WSEndpointTest >> testIsWSEndpoint [
	endpoint class isWSEndpoint should
]

{ #category : #'tests-other' }
WSEndpointTest >> testIsWSEndpointMethod [
	| httpMethods |

	httpMethods := endpoint class supportedHttpMethods.
	endpoint class methods
		do: [ :aMethod | 
			(httpMethods includes: aMethod selector)
				ifTrue: [ aMethod isWSEndpointExecutionMethod should ]
				ifFalse: [ aMethod isWSEndpointExecutionMethod should not ] ]
]

{ #category : #'tests-executing' }
WSEndpointTest >> testKeywordWithAbsoluteMixedPathExecution [
	self stubForExecution.
	endpoint getAbsoluteMixed: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #'tests-executing' }
WSEndpointTest >> testKeywordWithAbsolutePathExecution [
	self stubForExecution.
	endpoint getAbsoluteKeyword: 'foo'.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'foo') segments)
]

{ #category : #'tests-executing' }
WSEndpointTest >> testKeywordWithRelativeMixedPathExecution [
	self stubForExecution.
	endpoint getRelativeMixed: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #'tests-executing' }
WSEndpointTest >> testKeywordWithRelativePathExecution [
	self stubForExecution.
	endpoint getRelativeKeyword: 'foo'.
	http request url should equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'foo') segments)
]

{ #category : #'tests-composing' }
WSEndpointTest >> testPluggableEndpointComposition [
	| ep |
	ep := endpoint / 'pluggable'.
	ep class should equal: WSPluggableEndpoint.
	ep wsClient should equal: endpoint wsClient.
	ep endpointPath should equal: endpoint class endpointPath / 'pluggable'
]

{ #category : #'tests-executing' }
WSEndpointTest >> testUnaryExecution [
	self stubForExecution.
	endpoint get.
	http request url should equal: (client baseUrl addPathSegments: endpoint endpointPath segments)
]

{ #category : #'tests-executing' }
WSEndpointTest >> testUnaryWithAbsoluteDeepPathExecution [
	self stubForExecution.
	endpoint getAbsoluteDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'deep' / 'path') segments)
]

{ #category : #'tests-executing' }
WSEndpointTest >> testUnaryWithAbsolutePathExecution [
	self stubForExecution.
	endpoint getAbsolute.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'absolute') segments)
]

{ #category : #'tests-executing' }
WSEndpointTest >> testUnaryWithRelativeDeepPathExecution [
	self stubForExecution.
	endpoint getRelativeDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'deep' / 'path') segments)
]

{ #category : #'tests-executing' }
WSEndpointTest >> testUnaryWithRelativePathExecution [
	self stubForExecution.
	endpoint getRelative.
	http request url should
		equal:
			(client baseUrl
				addPathSegments: (endpoint endpointPath / 'relative') segments)
]

{ #category : #'tests-other' }
WSEndpointTest >> testWSEndpointHttpMethod [
	| httpMethods |

	httpMethods := endpoint class supportedHttpMethods.
	endpoint class methods
		do: [ :aMethod | 
			(httpMethods includes: aMethod selector)
				ifTrue: [ aMethod wsEndpointHttpMethod = aMethod selector ]
				ifFalse: [ aMethod isWSEndpointExecutionMethod should not ] ]
]
