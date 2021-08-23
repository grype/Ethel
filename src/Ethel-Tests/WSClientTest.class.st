Class {
	#name : #WSClientTest,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'Ethel-Tests-Core'
}

{ #category : #tests }
WSClientTest >> ensureEndpoint: aDestination derivedFrom: aSource as: aClass [
	aDestination class should equal: aClass.
	aDestination wsClient should equal: aSource
]

{ #category : #tests }
WSClientTest >> ensureEndpoint: aDestination derivedPluggableEndpointFrom: aSource usingPath: aPath [
	aDestination class should equal: WSPluggableEndpoint.
	aDestination wsClient should equal: aSource.
	aDestination endpointPath should equal: aPath
]

{ #category : #running }
WSClientTest >> setUp [
	client := WSTestClient default
]

{ #category : #tests }
WSClientTest >> testDerivedWSEndpoints [
	| derived |

	derived := client class derivedWSEndpoints.
	derived should
		equal:
			(Set new
				add: WSTestEndpoint;
				add: WSCollectionTestEndpoint;
				add: WSNestedTestEndpoint;
				yourself)
]

{ #category : #tests }
WSClientTest >> testEndpointCompositionWithClass [
	self
		ensureEndpoint: client / WSTestEndpoint
		derivedFrom: client
		as: WSTestEndpoint.

	self
		ensureEndpoint: client / #nowhere / #in / #particular
		derivedPluggableEndpointFrom: client
		usingPath: Path / #nowhere / #in / #particular
]

{ #category : #tests }
WSClientTest >> testEndpointCompositionWithPath [
	self
		ensureEndpoint: client / (Path / #test)
		derivedFrom: client
		as: WSPluggableEndpoint.

	self
		ensureEndpoint: client / (Path * #test)
		derivedFrom: client
		as: WSPluggableEndpoint.

	self
		ensureEndpoint: client / (Path / #nothing / #here)
		derivedPluggableEndpointFrom: client
		usingPath: Path / #nothing / #here
]

{ #category : #tests }
WSClientTest >> testEndpointCompositionWithString [
	self
		ensureEndpoint: client / #test
		derivedFrom: client
		as: WSPluggableEndpoint.

	self
		ensureEndpoint: client / #test / #nested
		derivedFrom: client
		as: WSPluggableEndpoint.

	self
		ensureEndpoint: client / 'test/nested'
		derivedFrom: client
		as: WSPluggableEndpoint.

	self
		ensureEndpoint: client / #nothing / #here
		derivedPluggableEndpointFrom: client
		usingPath: Path / #nothing / #here
]

{ #category : #tests }
WSClientTest >> testEndpoints [
	| derived |

	derived := client class endpoints.
	derived should
		equal:
			(Set new
				add: WSTestEndpoint;
				add: WSCollectionTestEndpoint;
				add: WSDetachedEmptyTestEndpoint;
				add: WSDetachedTestEndpoint;
				add: WSNestedTestEndpoint;
				yourself)
]

{ #category : #tests }
WSClientTest >> testExecute [
	| ep http response |

	http := ZnClient new.
	response := ZnResponse ok: (ZnEntity text: 'ok').
	ep := client test.

	http stub.
	client stub.
	ep stub.

	[ http execute willReturn: response.
	http response willReturn: response.
	client createHttpClient willReturn: http ] should expect.

	ep get should be: response.

	[ ep configureOn: (Instance of: ZnClient).
	client validateRequest: (Instance of: ZnRequest).
	http execute.
	client validateResponse: (Instance of: ZnResponse) ] should beDoneInOrder
]

{ #category : #tests }
WSClientTest >> testHttpClientCreation [
	client stub.
	client httpClientOnEndpoint: WSTestEndpoint new.
	client should receive configureOn: (Instance of: ZnClient)
]

{ #category : #tests }
WSClientTest >> testInitialization [
	client baseUrl should equal: client class baseUrl 
]

{ #category : #tests }
WSClientTest >> testIsWSEndpoint [
	client class isWSEndpoint should not
]

{ #category : #tests }
WSClientTest >> testPathReferences [
	| paths |

	paths := client class pathReferences.
	paths should
		equal: (client class endpoints flatCollect: #pathReferences)
]

{ #category : #tests }
WSClientTest >> testPluggableEndpointComposition [
	| ep |
	ep := client / 'pluggable'.
	ep class should equal: WSPluggableEndpoint.
	ep wsClient should equal: client.
	ep endpointPath should equal: Path / 'pluggable'.
]

{ #category : #tests }
WSClientTest >> testWithUrl [
	| url tempClient |
	url := 'https://example.com/foo/bar' asUrl.
	tempClient := WSClient withUrl: url.
	tempClient baseUrl should equal: url
]
