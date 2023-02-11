Trait {
	#name : #TWSTestEndpoint,
	#instVars : [
		'headers'
	],
	#traits : 'TWSEndpoint',
	#classTraits : 'TWSEndpoint classTrait',
	#category : #'Ethel-Tests-Models'
}

{ #category : #tests }
TWSTestEndpoint classSide >> testHeaderName [
	^ #'X-Test'
]

{ #category : #tests }
TWSTestEndpoint classSide >> testHeaderValue [
	^ 'Testing'
]

{ #category : #endpoints }
TWSTestEndpoint >> / aStringOrEndpoint [
	| ep |

	ep := self wsClient / aStringOrEndpoint.
	self headers associationsDo: [ :each | 
		(ep traitComposition includesTrait: TWSTestEndpoint) ifTrue: [ 
			ep headers add: each ] ].
	^ ep
]

{ #category : #'as yet unclassified' }
TWSTestEndpoint >> configure [
	WSCurrentContext value ifNotNil: [ :context | 
		context transport
			headerAt: self class testHeaderName
			put: self class testHeaderValue ]
]

{ #category : #accessing }
TWSTestEndpoint >> headers [
	^ headers ifNil: [ headers := Dictionary new ]
]

{ #category : #accessing }
TWSTestEndpoint >> headers: anObject [
	headers := anObject
]
