Trait {
	#name : #TUnrestEnumerating,
	#category : #'Unrest-Core'
}

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
TUnrestEnumerating >> errorNotFound: anObject [
	"Raise a NotFound exception."

	NotFound signalFor: anObject
]

{ #category : #enumerating }
TUnrestEnumerating >> select: aBlock [
	| result |

	result := OrderedCollection new.
	self enumerator all: [ :enum | (self enumerateWith: enum) ifNotNil: [ :val | result addAll: val ] ].
	^ result
]
