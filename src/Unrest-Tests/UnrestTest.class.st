Class {
	#name : #UnrestTest,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'Unrest-Tests-Core'
}

{ #category : #running }
UnrestTest >> setUp [
	client := UnrestTestClient default
]

{ #category : #tests }
UnrestTest >> testEndpointComposition [
	| ep |
	ep := client > UnrestTestEndpoint.
	self assert: ep class equals: UnrestTestEndpoint.
	self assert: ep unrest equals: client.
	self assert: ep endpointPath equals: UnrestTestEndpoint endpointPath.
]

{ #category : #tests }
UnrestTest >> testExecution [
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
UnrestTest >> testHttpClientCreation [
	client stub.
	client createHttpClient.
	client should receive configureHttpClient: (Instance of: ZnClient)
]

{ #category : #tests }
UnrestTest >> testHttpMethodValidation [
	client stub.
	client allowedHttpMethods do: [ :each | (client validateMethod: each) should be ].
	[ client validateMethod: #foo ] should raise: UnrestError
]

{ #category : #tests }
UnrestTest >> testImplementorsOfPath [
	| implementors |
	implementors := client implementorsOfPath: UnrestTestEndpoint endpointPath.
	self assert: implementors isEmptyOrNil not description: 'Failed to find any implementors of default endpoint path'
]

{ #category : #tests }
UnrestTest >> testInitialization [
	client baseUrl == client class baseUrl 
]

{ #category : #tests }
UnrestTest >> testPluggableEndpointComposition [
	| ep |
	ep := client / 'pluggable'.
	self assert: ep class equals: UnrestPluggableEndpoint.
	self assert: ep unrest equals: client.
	self assert: ep endpointPath equals: Path / 'pluggable'.
]
