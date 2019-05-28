Extension { #name : #Path }

{ #category : #'*Ethel' }
Path >> matches: aPathOrPattern [
	| other s1 s2 isRecursiveGlobbing b |

	other := aPathOrPattern asPath.
	(self isAbsolute and: [ other isAbsolute ])
		ifFalse: [ ^ false ].
	(self isEmpty and: [ other isEmpty ])
		ifTrue: [ ^ true ].
	s1 := ReadStream on: self.
	s2 := ReadStream on: other.
	isRecursiveGlobbing := false.

	s1
		do: [ :a | 
			b := s2 next.
			(b isNil and: [isRecursiveGlobbing]) ifTrue: [ ^ true ].
			((b isNotNil and: [b match: a])
				ifTrue: [ true ]
				ifFalse: [ isRecursiveGlobbing
						ifTrue: [ b := s2 back.
							b match: a ]
						ifFalse: [ false ] ])
				ifFalse: [ ^ false ].
			isRecursiveGlobbing := b includesSubstring: '**' ].
	^ s1 atEnd and: [ s2 atEnd ]
]

{ #category : #'*Ethel' }
Path >> wsGtPrintString [
	^ self pathString
]
