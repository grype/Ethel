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
			(self format: aHeaderBuilder headerValue) }
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestMethodBuilder: aBuilder [
	aBuilder httpMethod ifNotNil: [ :httpMethod | 
		transport method: httpMethod asUppercase ].

	aBuilder path ifNotNil: [ :path | 
		| url newPath |

		url := transport request url.
		newPath := context
			           ifNil: [ path ]
			           ifNotNil: [ :ctx | self format: path ].
		transport request url segments:
			(Path / url path resolve: newPath) segments ]
]

{ #category : #visiting }
WSZincTransportVisitor >> visitRequestQueryBuilder: aBuilder [
	transport request url perform: aBuilder selector withArguments: { 
			aBuilder queryKey.
			(self format: aBuilder queryValue) }
]
