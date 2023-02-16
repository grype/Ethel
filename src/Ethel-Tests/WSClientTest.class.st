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
	aDestination path should equal: aPath
]

{ #category : #running }
WSClientTest >> setUp [
	client := WSTestClient default
]

{ #category : #tests }
WSClientTest >> testCreateHttpClient [
	| http |
	http := client createHttpClient.
	http should beKindOf: ZnClient 
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
		usingPath: Path * #nowhere / #in / #particular
]

{ #category : #tests }
WSClientTest >> testEndpointCompositionWithPath [
	self
		ensureEndpoint: client / (Path / #test)
		derivedPluggableEndpointFrom: client
		usingPath: Path / #test.

	self
		ensureEndpoint: client / (Path * #test)
		derivedPluggableEndpointFrom: client
		usingPath: Path * #test.

	self
		ensureEndpoint: client / (Path / #nothing / #here)
		derivedPluggableEndpointFrom: client
		usingPath: Path / #nothing / #here
]

{ #category : #tests }
WSClientTest >> testEndpointCompositionWithString [
	self
		ensureEndpoint: client / #test
		derivedPluggableEndpointFrom: client
		usingPath: Path * #test.

	self
		ensureEndpoint: client / #test / #nested
		derivedPluggableEndpointFrom: client
		usingPath: Path * #test / #nested.

	self
		ensureEndpoint: client / 'test/nested'
		derivedPluggableEndpointFrom: client
		usingPath: Path * #test / #nested
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

	[ 
	http execute willReturn: response.
	http response willReturn: response.
	client createHttpClient willReturn: http.
	(client validateRequest: Any) willReturn: true. ] should expect.

	ep get should be: response.

	[ 
	ep configure.
	client validateRequest: (Instance of: ZnRequest).
	http execute.
	client validateResponse: (Instance of: ZnResponse) ] should
		beDoneInOrder
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
WSClientTest >> testPluggableEndpointComposition [

	| ep |
	ep := client / 'pluggable'.
	ep class should equal: WSPluggableEndpoint.
	ep wsClient should equal: client
]
