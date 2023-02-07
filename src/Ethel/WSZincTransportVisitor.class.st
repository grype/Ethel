"
I implement `TWSTransportVisitor` for `ZnClient`.
"
Class {
	#name : #WSZincTransportVisitor,
	#superclass : #Object,
	#traits : 'TWSTransportVisitor',
	#classTraits : 'TWSTransportVisitor classTrait',
	#category : #'Ethel-Builders'
}

{ #category : #visiting }
WSZincTransportVisitor >> currentPath [
	| currentPath |
	currentPath := transport request url ifNotNil: [ :url | 
		               url path ifEmpty: [ nil ] ].
	^ currentPath
		  ifNil: [ Path root ]
		  ifNotNil: [ :aPath | Path root / aPath ]
]

{ #category : #visiting }
WSZincTransportVisitor >> resolvePath: aPath [
	^ self currentPath resolve: (context
			   ifNil: [ aPath ]
			   ifNotNil: [ :ctx | aPath format: ctx wsEndpointTemps ])
]

{ #category : #visiting }
WSZincTransportVisitor >> visitContentBuilder: aBuilder [
	aBuilder contentReader ifNotNil: [ :aReader | 
		transport contentReader: aReader ].
	aBuilder contentWriter ifNotNil: [ :aWriter | 
		transport contentWriter: aWriter ]
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestHeaderBuilder: aHeaderBuilder [
	transport perform: aHeaderBuilder selector withArguments: { 
			aHeaderBuilder headerKey.
			(aHeaderBuilder headerValue format: context wsEndpointTemps) }
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestMethodBuilder: aBuilder [
	aBuilder httpMethod ifNotNil: [ :aMethod | 
		transport method: aMethod asUppercase ].
	aBuilder path ifNotNil: [ :aPath | 
		transport request url segments: (self resolvePath: aPath) segments ]
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestQueryBuilder: aBuilder [
	transport request url perform: aBuilder selector withArguments: { 
			aBuilder queryKey.
			(aBuilder queryValue format: context wsEndpointTemps) }
]
