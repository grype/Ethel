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
UnrestEndpointTest >> testEndpointComposition [
	| ep |

	ep := endpoint > UnrestAnotherTestEndpoint.
	self assert: ep class equals: UnrestAnotherTestEndpoint.
	self assert: ep unrest equals: endpoint unrest.
	self assert: ep endpointPath equals: UnrestAnotherTestEndpoint endpointPath.
	self assert: (ep headers keys includesAll: endpoint headers keys) description: 'Derived endpoint was not correctly conifgured'.
]

{ #category : #tests }
UnrestEndpointTest >> testPluggableEndpointComposition [
	| ep |
	ep := endpoint / 'pluggable'.
	self assert: ep class equals: UnrestPluggableEndpoint.
	self assert: ep unrest equals: endpoint unrest.
	self assert: ep endpointPath equals: endpoint class endpointPath / 'pluggable'
]
