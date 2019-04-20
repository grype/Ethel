Extension { #name : #Context }

{ #category : #'*Unrest' }
Context >> wsEndpointHttpMethodUsing: aListOfMethods [
	| validMethods |

	validMethods := aListOfMethods
		collect: [ :each | each asLowercase asSymbol ].
	^ self method pragmas
		detect: [ :each | validMethods includes: each keyword asLowercase asSymbol ]
		ifFound: [ :val | val keyword ]
		ifNone: [ nil ]
]

{ #category : #'*Unrest' }
Context >> wsEndpointPath [
	^ self method isWSEndpointMethod
		ifTrue: [ self method wsEndpointPath ]
		ifFalse: [ nil ]
]

{ #category : #'*Unrest' }
Context >> wsEndpointTemps [
	^ (self tempNames collect: [ :each | each -> (self tempNamed: each) ])
		asDictionary
]

{ #category : #'*Unrest' }
Context >> wsEndpointValues [
	^ self receiver class allSlots
		ifEmpty: [ Dictionary new ]
		ifNotEmpty: [ :val | 
			(val groupedBy: #name)
				collect: [ :each | each first read: self receiver ] ]
]
