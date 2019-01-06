Class {
	#name : #UnrestCollectionTestEndpoint,
	#superclass : #Object,
	#traits : 'TUnrestTestEndpoint + TUnrestEnumerating',
	#classTraits : 'TUnrestTestEndpoint classTrait + TUnrestEnumerating classTrait',
	#instVars : [
		'offset',
		'limit',
		'headers',
		'unrest'
	],
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
UnrestCollectionTestEndpoint class >> endpointPath [
	^ Path / 'another-test'
]

{ #category : #enumerating }
UnrestCollectionTestEndpoint >> cursor [
	^ UnrestTestCursor new
		offset: offset;
		total: limit * 2.5;
		yourself
]

{ #category : #enumerating }
UnrestCollectionTestEndpoint >> enumerateWith: aCursor limit: aLimit [
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

{ #category : #initialization }
UnrestCollectionTestEndpoint >> initialize [
	super initialize.
	limit := 2.
	offset := 0
]

{ #category : #accessing }
UnrestCollectionTestEndpoint >> limit [
	^ limit
]

{ #category : #accessing }
UnrestCollectionTestEndpoint >> limit: anObject [
	limit := anObject
]

{ #category : #accessing }
UnrestCollectionTestEndpoint >> offset [
	^ offset
]

{ #category : #accessing }
UnrestCollectionTestEndpoint >> offset: anObject [
	offset := anObject
]

{ #category : #printing }
UnrestCollectionTestEndpoint >> printOn: aStream [
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
UnrestCollectionTestEndpoint >> size [
	^ offset
]

{ #category : #tests }
UnrestCollectionTestEndpoint >> test [
	<endpoint>
	<get>
	^ self execute
]
