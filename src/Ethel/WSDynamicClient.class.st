Class {
	#name : #WSDynamicClient,
	#superclass : #WSClient,
	#instVars : [
		'transportBuilders'
	],
	#category : #'Ethel-Core'
}

{ #category : #adding }
WSDynamicClient >> addTransportBuilder: aBuilder [
	transportBuilders add: aBuilder
]

{ #category : #configuring }
WSDynamicClient >> configure [
	| visitor |

	super configure.
	visitor := WSZincTransportVisitor new.
	transportBuilders do: [ :aBuilder | aBuilder accept: visitor ]
]

{ #category : #initialization }
WSDynamicClient >> initialize [
	super initialize.
	transportBuilders := OrderedCollection new
]
