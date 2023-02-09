"
I describe a complete interface for configuring http transport object for execution.

I am modeled to work with `ZnClient`, and thus there's an `ZnClient` implementation in `WSZincTransportVisitor`.
"
Trait {
	#name : #TWSTransportVisitor,
	#category : #'Ethel-Builders'
}

{ #category : #visiting }
TWSTransportVisitor >> visitContentBuilder: aBuilder [
]

{ #category : #visiting }
TWSTransportVisitor >> visitRequestHeaderBuilder: aBuilder [
]

{ #category : #visiting }
TWSTransportVisitor >> visitRequestMethodBuilder: aBuilder [
]

{ #category : #visiting }
TWSTransportVisitor >> visitRequestQueryBuilder: aBuilder [
]
