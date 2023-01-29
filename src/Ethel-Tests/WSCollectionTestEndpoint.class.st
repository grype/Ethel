Class {
	#name : #WSCollectionTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSTestEndpoint + TWSEnumeration',
	#classTraits : 'TWSTestEndpoint classTrait + TWSEnumeration classTrait',
	#instVars : [
		'offset',
		'limit',
		'headers',
		'unrest'
	],
	#category : #'Ethel-Tests-Models'
}

{ #category : #enumerating }
WSCollectionTestEndpoint >> cursor [
	^ WSTestCursor new
		offset: offset;
		total: limit * 2.5;
		yourself
]

{ #category : #initialization }
WSCollectionTestEndpoint >> initialize [
	super initialize.
	limit := 2.
	offset := 0
]

{ #category : #accessing }
WSCollectionTestEndpoint >> limit [
	^ limit
]

{ #category : #accessing }
WSCollectionTestEndpoint >> limit: anObject [
	limit := anObject
]

{ #category : #enumerating }
WSCollectionTestEndpoint >> next: aLimit with: aCursor [
	| response result contents |

	offset := aCursor offset.
	aLimit ifNotNil: [ limit := aLimit ].
	response := self test.
	response isSuccess
		ifFalse: [ ^ nil ].

	contents := response contents value.
	result := contents isString
		ifTrue: [ NeoJSONReader fromString: contents ]
		ifFalse: [ contents ].
	aCursor offset: offset + result size.
	^ result
]

{ #category : #accessing }
WSCollectionTestEndpoint >> offset [
	^ offset
]

{ #category : #accessing }
WSCollectionTestEndpoint >> offset: anObject [
	offset := anObject
]

{ #category : #printing }
WSCollectionTestEndpoint >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' limit: ';
		print: limit.
	aStream
		nextPutAll: ' offset: ';
		print: offset
]

{ #category : #accessing }
WSCollectionTestEndpoint >> size [
	^ offset
]

{ #category : #tests }
WSCollectionTestEndpoint >> test [
	<get>
	^ self execute
]
