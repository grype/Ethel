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
