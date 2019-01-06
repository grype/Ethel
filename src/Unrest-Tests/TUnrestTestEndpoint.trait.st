Trait {
	#name : #TUnrestTestEndpoint,
	#instVars : [
		'headers'
	],
	#traits : 'TUnrestEndpoint',
	#classTraits : 'TUnrestEndpoint classTrait',
	#category : #'Unrest-Tests-Models'
}

{ #category : #tests }
TUnrestTestEndpoint classSide >> testHeaderName [
	^ #'X-Test'
]

{ #category : #tests }
TUnrestTestEndpoint classSide >> testHeaderValue [
	^ 'Testing'
]

{ #category : #configuring }
TUnrestTestEndpoint >> configureDerivedEndpoint: anEndpoint [
	self headers associationsDo: [ :each | anEndpoint headers add: each ]
]

{ #category : #configuring }
TUnrestTestEndpoint >> configureOn: http [
	http headerAt: self class testHeaderName put: self class testHeaderValue 
]

{ #category : #accessing }
TUnrestTestEndpoint >> headers [
	^ headers ifNil: [ headers := Dictionary new ]
]

{ #category : #accessing }
TUnrestTestEndpoint >> headers: anObject [
	headers := anObject
]
