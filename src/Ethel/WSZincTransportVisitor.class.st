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

	aBuilder httpMethod ifNotNil: [ :val | 
		transport method: val asUppercase ].
	aBuilder path ifNotNil: [ :val | 
		| url newPath p |
		url := transport request url.
		newPath := context
			           ifNil: [ val ]
			           ifNotNil: [ :ctx | val format: ctx wsEndpointTemps ].
		p := Path root.
		url path isEmptyOrNil ifFalse: [ p := p / url path ].
		transport request url segments: (p resolve: newPath) segments ]
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestQueryBuilder: aBuilder [
	transport request url perform: aBuilder selector withArguments: { 
			aBuilder queryKey.
			(aBuilder queryValue format: context wsEndpointTemps) }
]
