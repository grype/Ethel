Extension { #name : #String }

{ #category : #'*Ethel-Tools' }
String >> formatTokens [
	"Extracts format tokens from the receiver, as in the following examples:  
	'Today is {1}.' formatTokens. ""#(#1)""
	'Today is {date}.' formatTokens. ""#(#date)"" "

	| result stream |
	stream := self readStream.
	result := Set new.
	[ stream atEnd ]
		whileFalse: [ | currentChar |
			(currentChar := stream next) == ${
				ifTrue: [ (stream upTo: $}) ifNotEmpty: [ :val | result add: val ] ] ].
	^ result
]
