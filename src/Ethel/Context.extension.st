Extension { #name : #Context }

{ #category : #'*Ethel' }
Context >> wsEndpointHttpMethodUsing: aListOfMethods [
	| validMethods |

	validMethods := aListOfMethods
		collect: [ :each | each asLowercase asSymbol ].
	^ self method pragmas
		detect: [ :each | validMethods includes: each keyword asLowercase asSymbol ]
		ifFound: [ :val | val keyword ]
		ifNone: [ nil ]
]

{ #category : #'*Ethel' }
Context >> wsEndpointPath [
	^ self method isWSEndpointExecutionMethod
		ifTrue: [ self method wsEndpointPath ]
		ifFalse: [ nil ]
]

{ #category : #'*Ethel' }
Context >> wsEndpointTemps [
	^ (self tempNames collect: [ :each | each -> (self tempNamed: each) ])
		asDictionary
]

{ #category : #'*Ethel' }
Context >> wsEndpointValues [
	^ self receiver class allSlots
		ifEmpty: [ Dictionary new ]
		ifNotEmpty: [ :val | 
			(val groupedBy: #name)
				collect: [ :each | each first read: self receiver ] ]
]
