Trait {
	#name : #TUnrestEnumerating,
	#category : #'Unrest-Core'
}

{ #category : #enumerating }
TUnrestEnumerating >> collect: aBlock [
	^ self collect: aBlock as: OrderedCollection 
]

{ #category : #enumerating }
TUnrestEnumerating >> collect: aBlock as: aClass [
	| result cursor |

	result := aClass new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | result addAll: (val collect: aBlock) ] ].
	^ result
]

{ #category : #accessing }
TUnrestEnumerating >> cursor [
	^ self subclassResponsibility
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock [ 
	^ self detect: aBlock ifNone: [ self errorNotFound: aBlock ]
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock ifFound: foundBlock [
	^ self detect: aBlock ifFound: foundBlock ifNone: [  ]
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock ifFound: foundBlock ifNone: noneBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :values | values detect: aBlock ifFound: [ :val | ^ foundBlock cull: val ] ifNone: [  ] ] ].
	^ noneBlock value
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock ifNone: exceptionBlock [
	^ self detect: aBlock ifFound: [ :val | val ] ifNone: exceptionBlock 
]

{ #category : #enumerating }
TUnrestEnumerating >> do: aBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ] whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | val do: aBlock ] ]
]

{ #category : #enumerating }
TUnrestEnumerating >> enumerateWith: aCursor [
	^ self subclassResponsibility
]

{ #category : #'error handling' }
TUnrestEnumerating >> errorNotFound: anObject [
	"Raise a NotFound exception."

	NotFound signalFor: anObject
]

{ #category : #enumerating }
TUnrestEnumerating >> next: aBlock [
	aBlock cull: (self enumerateWith: self cursor)
]

{ #category : #enumerating }
TUnrestEnumerating >> reject: aBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val reject: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].

	^ result
]

{ #category : #enumerating }
TUnrestEnumerating >> select: aBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val select: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].
	^ result
]
