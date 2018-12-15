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
	| result |

	result := aClass new.
	self enumerator
		all:
			[ :enum | (self enumerateWith: enum) ifNotNil: [ :val | result addAll: (val collect: aBlock) ] ].
	^ result
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
	self enumerator
		all: [ :enum | 
			(self enumerateWith: enum)
				ifNotNil: [ :values | values detect: aBlock ifFound: [ :val | ^ foundBlock cull: val ] ifNone: [  ] ] ].
	^ noneBlock value
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock ifNone: exceptionBlock [
	^ self detect: aBlock ifFound: [ :val | val ] ifNone: exceptionBlock 
]

{ #category : #enumerating }
TUnrestEnumerating >> do: aBlock [
	self enumerator all: [ :enum | (self enumerateWith: enum) ifNotNil: [ :val | val do: aBlock ] ]
]

{ #category : #enumerating }
TUnrestEnumerating >> enumerateWith: enumerator [
	^ self subclassResponsibility
]

{ #category : #accessing }
TUnrestEnumerating >> enumerator [
	^ self subclassResponsibility
]

{ #category : #'error handling' }
TUnrestEnumerating >> errorNotFound: anObject [
	"Raise a NotFound exception."

	NotFound signalFor: anObject
]

{ #category : #enumerating }
TUnrestEnumerating >> reject: aBlock [
	| result |

	result := OrderedCollection new.
	self enumerator
		all: [ :enum | 
			(self enumerateWith: enum)
				ifNotNil: [ :val | (val reject: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].
	^ result
]

{ #category : #enumerating }
TUnrestEnumerating >> select: aBlock [
	| result |

	result := OrderedCollection new.
	self enumerator
		all: [ :enum | 
			(self enumerateWith: enum)
				ifNotNil: [ :val | (val select: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].
	^ result
]
