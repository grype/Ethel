Class {
	#name : #WSAbstractTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSEndpoint',
	#classTraits : 'TWSEndpoint classTrait',
	#category : #'Unrest-Tests'
}

{ #category : #executing }
WSAbstractTestEndpoint >> executingContext [
	| sender |

	sender := thisContext sender.
	[ sender isNotNil and: [ sender method isWSEndpointExecutionMethod not ] ]
		whileTrue: [ sender := sender sender ].

	^ sender
]
