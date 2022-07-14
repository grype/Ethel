"
I describe a complete interface for configuring http transport object for execution.

I am modeled to work with `ZnClient`, and thus there's an `ZnClient` implementation in `WSZincTransportVisitor`.
"
Trait {
	#name : #TWSTransportVisitor,
	#instVars : [
		'transport',
		'context'
	],
	#category : #'Ethel-Builders'
}

{ #category : #'instance creation' }
TWSTransportVisitor classSide >> onTransport: aTransport inContext: aContext [
	^ self basicNew initializeWithTransport: aTransport inContext: aContext
]

{ #category : #accessing }
TWSTransportVisitor >> context [

	^ context
]

{ #category : #accessing }
TWSTransportVisitor >> context: anObject [

	context := anObject
]

{ #category : #visiting }
TWSTransportVisitor >> format: aStringOrValueNode [
	^ context ifNil: [ aStringOrValueNode ] ifNotNil: [ :ctx | 
		  (aStringOrValueNode isKindOf: RBValueNode)
			  ifTrue: [ aStringOrValueNode evaluateForContext: ctx ]
			  ifFalse: [ aStringOrValueNode format: ctx wsEndpointTemps ] ]
]

{ #category : #initialization }
TWSTransportVisitor >> initializeWithTransport: aTransport inContext: aContext [
	self initialize.
	transport := aTransport.
	context := aContext
]

{ #category : #accessing }
TWSTransportVisitor >> transport [

	^ transport
]

{ #category : #accessing }
TWSTransportVisitor >> transport: anObject [

	transport := anObject
]

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
