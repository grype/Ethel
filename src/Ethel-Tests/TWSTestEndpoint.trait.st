Trait {
	#name : #TWSTestEndpoint,
	#instVars : [
		'headers'
	],
	#traits : 'TWSEndpoint',
	#classTraits : 'TWSEndpoint classTrait',
	#category : #'Ethel-Tests-Models'
}

{ #category : #'as yet unclassified' }
TWSTestEndpoint classSide >> pathPrefix [
	^ Path / #test
]

{ #category : #tests }
TWSTestEndpoint classSide >> testHeaderName [
	^ #'X-Test'
]

{ #category : #tests }
TWSTestEndpoint classSide >> testHeaderValue [
	^ 'Testing'
]

{ #category : #configuring }
TWSTestEndpoint >> configureDerivedEndpoint: anEndpoint [
	self headers
		associationsDo: [ :each | 
			(anEndpoint traitComposition includesTrait: TWSTestEndpoint)
				ifTrue: [ anEndpoint headers add: each ] ]
]

{ #category : #configuring }
TWSTestEndpoint >> configureOn: http [
	http headerAt: self class testHeaderName put: self class testHeaderValue 
]

{ #category : #accessing }
TWSTestEndpoint >> headers [
	^ headers ifNil: [ headers := Dictionary new ]
]

{ #category : #accessing }
TWSTestEndpoint >> headers: anObject [
	headers := anObject
]
