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
