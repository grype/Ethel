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

{ #category : #enumerating }
WSDynamicClient >> beforeRequestDo: aBlock [
	self addTransportBuilder: (WSContextBuilder with: aBlock)
]

{ #category : #configuring }
WSDynamicClient >> configure [
	| visitor |

	super configure.
	visitor := WSZincTransportVisitor new.
	transportBuilders do: [ :aBuilder | aBuilder accept: visitor ]
]

{ #category : #building }
WSDynamicClient >> expectJsonContent [
	self addTransportBuilder: WSJsonContentBuilder new
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

{ #category : #building }
WSDynamicClient >> queryAt: aHeader add: aValue [
	self addTransportBuilder: (WSRequestQueryBuilder new
			 queryKey: aHeader;
			 queryValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #building }
WSDynamicClient >> queryAt: aHeader put: aValue [
	self addTransportBuilder: (WSRequestQueryBuilder new
			 queryKey: aHeader;
			 queryValue: aValue;
			 selector: thisContext method selector;
			 yourself)
]

{ #category : #'as yet unclassified' }
WSDynamicClient >> readContents: aBlock [
	self addTransportBuilder: (WSContentBuilder new reader: aBlock)
]

{ #category : #'as yet unclassified' }
WSDynamicClient >> writeContents: aBlock [
	self addTransportBuilder: (WSContentBuilder new writer: aBlock)
]
