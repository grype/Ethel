"
I capture request execution context.

This includes the transport object that will be performing the network request, the endpoint object from which the request was initiated, and the sender's `Context`.

You normally don't have to create an instance of me - one is created for the duration of the request execution. You can get the current context by sending `WSCurrentContext class>>#value`.
"
Class {
	#name : #WSContext,
	#superclass : #Object,
	#instVars : [
		'transport',
		'endpoint',
		'senderContext',
		'sender'
	],
	#category : #'Ethel-Core'
}

{ #category : #accessing }
WSContext >> endpoint [

	^ endpoint
]

{ #category : #accessing }
WSContext >> endpoint: anObject [

	endpoint := anObject
]

{ #category : #accessing }
WSContext >> initialize [
	super initialize.
	sender := thisContext sender.
	[ 
	sender isNotNil and: [ 
		(sender method isKindOf: CompiledMethod) not or: [ 
			sender method isWSEndpointExecutionMethod not ] ] ] whileTrue: [ 
		sender := sender sender ]
]

{ #category : #accessing }
WSContext >> sender [
	^ sender
]

{ #category : #accessing }
WSContext >> sender: anObject [

	^ sender := anObject
]

{ #category : #accessing }
WSContext >> transport [

	^ transport
]

{ #category : #accessing }
WSContext >> transport: anObject [

	transport := anObject
]
