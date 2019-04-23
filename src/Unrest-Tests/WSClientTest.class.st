Class {
	#name : #WSClientTest,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'Unrest-Tests-Core'
}

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
			(Set
				with: WSTestEndpoint
				with: WSCollectionTestEndpoint
				with: WSPluggableEndpoint)
]

{ #category : #tests }
WSClientTest >> testEndpointComposition [
	| ep |
	ep := client > WSTestEndpoint.
	ep class should equal: WSTestEndpoint.
	ep wsClient should equal: client.
	ep endpointPath should equal: WSTestEndpoint endpointPath.
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
	client createHttpClient.
	client should receive configureHttpClient: (Instance of: ZnClient)
]

{ #category : #tests }
WSClientTest >> testImplementorsOfPath [
	| implementors |
	implementors := client implementorsOfPath: WSTestEndpoint endpointPath.
	implementors isEmptyOrNil should not be
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
		equal:
			WSTestEndpoint pathReferences
				, WSCollectionTestEndpoint pathReferences
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
