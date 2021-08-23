Class {
	#name : #TWSEndpointTest,
	#superclass : #TestCase,
	#instVars : [
		'client',
		'endpoint',
		'cursor',
		'http'
	],
	#category : #'Ethel-Tests-Core'
}

{ #category : #'tests-composing' }
TWSEndpointTest >> ensureEndpoint: aDestination derivedFrom: aSource as: aClass [
	aDestination class should equal: aClass.
	aDestination wsClient should equal: aSource wsClient.
	(aDestination headers keys includesAll: aSource headers keys) should be
]

{ #category : #'tests-composing' }
TWSEndpointTest >> ensureEndpoint: aDestination derivedPluggableEndpointFrom: aSource usingPath: aPath [
	aDestination class should equal: WSPluggableEndpoint.
	aDestination wsClient should equal: aSource wsClient.
	aDestination endpointPath should equal: aPath.
	(aDestination class traitComposition includesTrait: TWSEndpointTest)
		ifTrue: [ (aDestination headers keys includesAll: aSource headers keys) should
				be ]
]

{ #category : #stubbing }
TWSEndpointTest >> okJsonResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity json: aValue asJson)
]

{ #category : #stubbing }
TWSEndpointTest >> okResponse [
	^ ZnResponse ok: (ZnEntity text: 'ok')
]

{ #category : #stubbing }
TWSEndpointTest >> okResponseWith: aValue [
	^ ZnResponse ok: (ZnEntity with: aValue)
]

{ #category : #running }
TWSEndpointTest >> setUp [
	client := WSTestClient default.
	endpoint := WSTestEndpoint on: client.
]

{ #category : #stubbing }
TWSEndpointTest >> stubForEnumeration [
	endpoint := client collection.
	cursor := self stubbedCursor.
	http := self
		stubbedHttpWithResponse:
			(self
				okResponseWith: [ (endpoint offset to: (cursor total min: endpoint offset + endpoint limit) - 1) asArray ])
]

{ #category : #stubbing }
TWSEndpointTest >> stubForExecution [
	http := self stubbedHttpWithResponse: self okResponse
]

{ #category : #stubbing }
TWSEndpointTest >> stubHttp: http withResponse: aResponse [
	http stub execute willReturn: aResponse.
	http stub response willReturn: aResponse
]

{ #category : #stubbing }
TWSEndpointTest >> stubbedCursor [
	| aCursor |
	aCursor := endpoint cursor.
	endpoint stub cursor willReturn: aCursor.
	^ aCursor
]

{ #category : #stubbing }
TWSEndpointTest >> stubbedHttp [
	^ self stubbedHttpWithResponse: nil
]

{ #category : #stubbing }
TWSEndpointTest >> stubbedHttpWithResponse: aResponse [
	| http |

	http := client createHttpClient.
	aResponse ifNotNil: [ :val | self stubHttp: http withResponse: val ].

	client stub createHttpClient willReturn: http.
	^ http
]

{ #category : #'tests-configuring' }
TWSEndpointTest >> testConfigureOn [
	endpoint stub.
	http := client httpClientOnEndpoint: endpoint.
	http request headers should
		include: WSTestEndpoint testHeaderValue
		at: WSTestEndpoint testHeaderName
]

{ #category : #'tests-composing' }
TWSEndpointTest >> testEndpointCompositionWithClass [
	self
		ensureEndpoint: endpoint / WSCollectionTestEndpoint
		derivedFrom: endpoint
		as: WSCollectionTestEndpoint.

	self
		ensureEndpoint: endpoint / #this / #goes / #nowhere / WSCollectionTestEndpoint
		derivedFrom: endpoint
		as: WSCollectionTestEndpoint
]

{ #category : #'tests-composing' }
TWSEndpointTest >> testEndpointCompositionWithPath [
	self
		ensureEndpoint: endpoint / (Path * #nested)
		derivedPluggableEndpointFrom: endpoint
		usingPath: Path / #test / #nested.

	self
		ensureEndpoint: endpoint / (Path / #test / #nested)
		derivedPluggableEndpointFrom: endpoint
		usingPath: Path / #test / #nested.

	self
		ensureEndpoint: endpoint / (Path / #nested)
		derivedPluggableEndpointFrom: endpoint
		usingPath: Path / #nested.

	self
		ensureEndpoint: endpoint / (Path / #test)
		derivedPluggableEndpointFrom: endpoint
		usingPath: Path / #test
]

{ #category : #'tests-composing' }
TWSEndpointTest >> testEndpointCompositionWithString [
	self
		ensureEndpoint: endpoint / #nested
		derivedPluggableEndpointFrom: endpoint
		usingPath: Path / #test / #nested.
]

{ #category : #'tests-enumerating' }
TWSEndpointTest >> testEnumerationDetect [
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
TWSEndpointTest >> testEnumerationDetectNotFound [
	| result |

	self stubForEnumeration.

	endpoint offset should be: 0.
	result := endpoint detect: [ :responseResult | responseResult > cursor total ] ifNone: [ nil ].
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor offset.
	result should be: nil
]

{ #category : #'tests-enumerating' }
TWSEndpointTest >> testEnumerationDetectRaiseNotFound [
	self stubForEnumeration.
	endpoint offset should be: 0.
	[ endpoint detect: [ :responseResult | responseResult > cursor total ] ] should raise: NotFound.
	http should receive execute exactly: (cursor total / endpoint limit) rounded.
	cursor offset should equal: cursor offset
]

{ #category : #'tests-enumerating' }
TWSEndpointTest >> testEnumerationDo [
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
TWSEndpointTest >> testEnumerationFirst [
	self stubForEnumeration.
	endpoint offset should be: 0.
	endpoint first should equal: 0.
	cursor offset should be: endpoint limit.
	http should receive execute
]

{ #category : #'tests-enumerating' }
TWSEndpointTest >> testEnumerationNext [
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
TWSEndpointTest >> testEnumerationSelect [
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
TWSEndpointTest >> testHttpMethod [
	| stubbedHttp |

	stubbedHttp := self stubbedHttpWithResponse: self okResponse.
	client class httpMethods
		do: [ :method | 
			endpoint perform: method.
			stubbedHttp request method asLowercase should equal: method asLowercase ]
]

{ #category : #'tests-other' }
TWSEndpointTest >> testIsWSEndpoint [
	endpoint class isWSEndpoint should
]

{ #category : #'tests-other' }
TWSEndpointTest >> testIsWSEndpointMethod [
	| httpMethods |

	httpMethods := client class httpMethods.
	endpoint class methods
		do: [ :aMethod | 
			(httpMethods includes: aMethod selector)
				ifTrue: [ aMethod isWSEndpointExecutionMethod should ]
				ifFalse: [ aMethod isWSEndpointExecutionMethod should not ] ]
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testKeywordWithAbsoluteMixedPathExecution [
	self stubForExecution.
	endpoint getAbsoluteMixed: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testKeywordWithAbsolutePathExecution [
	self stubForExecution.
	endpoint getAbsoluteKeyword: 'foo'.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'foo') segments)
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testKeywordWithRelativeMixedPathExecution [
	self stubForExecution.
	endpoint getRelativeMixed: 'foo'.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'mixed' / 'foo' / 'path') segments)
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testKeywordWithRelativePathExecution [
	self stubForExecution.
	endpoint getRelativeKeyword: 'foo'.
	http request url should equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'foo') segments)
]

{ #category : #tests }
TWSEndpointTest >> testOn [
	| tempEndpoint |

	tempEndpoint := WSTestEndpoint on: client.
	tempEndpoint wsClient should equal: client
]

{ #category : #tests }
TWSEndpointTest >> testPathReferences [
	| execMethods refs |

	execMethods := (endpoint class methods
		select: [ :each | each category = #'private-executing' ]) asSet.
	refs := endpoint class pathReferences asSet.
	(refs collect: #key) should equal: execMethods
]

{ #category : #'tests-composing' }
TWSEndpointTest >> testPluggableEndpointComposition [
	| ep |
	ep := endpoint / 'pluggable'.
	ep class should equal: WSPluggableEndpoint.
	ep wsClient should equal: endpoint wsClient.
	ep endpointPath should equal: endpoint endpointPath / 'pluggable'
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testUnaryExecution [
	self stubForExecution.
	endpoint get.
	http request url should equal: (client baseUrl addPathSegments: endpoint endpointPath segments)
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testUnaryWithAbsoluteDeepPathExecution [
	self stubForExecution.
	endpoint getAbsoluteDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (Path / 'absolute' / 'deep' / 'path') segments)
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testUnaryWithAbsolutePathExecution [
	self stubForExecution.
	endpoint getAbsolute.
	http request url should equal: (client baseUrl addPathSegments: (Path / 'absolute') segments)
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testUnaryWithRelativeDeepPathExecution [
	self stubForExecution.
	endpoint getRelativeDeep.
	http request url should
		equal: (client baseUrl addPathSegments: (endpoint endpointPath / 'relative' / 'deep' / 'path') segments)
]

{ #category : #'tests-executing' }
TWSEndpointTest >> testUnaryWithRelativePathExecution [
	self stubForExecution.
	endpoint getRelative.
	http request url should
		equal:
			(client baseUrl
				addPathSegments: (endpoint endpointPath / 'relative') segments)
]

{ #category : #'tests-other' }
TWSEndpointTest >> testWSEndpointAccessor [
	| httpMethods |

	httpMethods := client class httpMethods.
	endpoint class methods
		do: [ :aMethod | 
			(httpMethods includes: aMethod selector)
				ifTrue: [ aMethod wsEndpointAccessor method = aMethod selector ]
				ifFalse: [ aMethod isWSEndpointExecutionMethod should not ] ]
]
