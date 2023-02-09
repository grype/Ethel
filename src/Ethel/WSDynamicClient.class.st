Class {
	#name : #WSDynamicClient,
	#superclass : #WSClient,
	#instVars : [
		'transportBuilders'
	],
	#category : #'Ethel-Core'
}

{ #category : #building }
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

{ #category : #building }
WSDynamicClient >> headerAt: aHeader add: aValue [
	self addTransportBuilder: (WSRequestHeaderBuilder new
			 headerKey: aHeader;
			 headerValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #building }
WSDynamicClient >> headerAt: aHeader put: aValue [
	self addTransportBuilder: (WSRequestHeaderBuilder new
			 headerKey: aHeader;
			 headerValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #initialization }
WSDynamicClient >> initialize [
	super initialize.
	transportBuilders := OrderedCollection new
]
