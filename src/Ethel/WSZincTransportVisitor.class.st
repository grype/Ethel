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
WSZincTransportVisitor >> context [
	^ WSCurrentContext value
]

{ #category : #visiting }
WSZincTransportVisitor >> currentPath [
	| currentPath |

	currentPath := self transport request url ifNotNil: [ :url | 
		               url path ifEmpty: [ nil ] ].
	^ currentPath
		  ifNil: [ Path root ]
		  ifNotNil: [ :aPath | Path root / aPath ]
]

{ #category : #visiting }
WSZincTransportVisitor >> resolvePath: aPath [
	^ self currentPath resolve: (self sender
			   ifNil: [ aPath ]
			   ifNotNil: [ :ctx | aPath format: ctx wsEndpointTemps ])
]

{ #category : #visiting }
WSZincTransportVisitor >> sender [
	^ self context ifNotNil: [ :aContext | aContext sender ]
]

{ #category : #visiting }
WSZincTransportVisitor >> transport [
	^ self context ifNotNil: [ :aContext | aContext transport ]
]

{ #category : #visiting }
WSZincTransportVisitor >> visitContentBuilder: aBuilder [
	aBuilder contentReader ifNotNil: [ :aReader | 
		self transport contentReader: aReader ].
	aBuilder contentWriter ifNotNil: [ :aWriter | 
		self transport contentWriter: aWriter ]
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestHeaderBuilder: aHeaderBuilder [
	self transport perform: aHeaderBuilder selector withArguments: { 
			aHeaderBuilder headerKey.
			(aHeaderBuilder headerValue format:
				 self sender wsEndpointTemps) }
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestMethodBuilder: aBuilder [
	aBuilder httpMethod ifNotNil: [ :aMethod | 
		self transport method: aMethod asUppercase ].
	aBuilder path ifNotNil: [ :aPath | 
		self transport request url segments: (self resolvePath: aPath) segments ]
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestQueryBuilder: aBuilder [
	self transport request url
		perform: aBuilder selector
		withArguments: { 
				aBuilder queryKey.
				(self sender
					 ifNil: [ aBuilder queryValue ]
					 ifNotNil: [ :sender | 
					 aBuilder queryValue format: sender wsEndpointTemps ]) }
]
