Class {
	#name : #UnrestAnotherTestEndpoint,
	#superclass : #UnrestAbstractTestEndpoint,
	#traits : 'TUnrestEnumerating',
	#classTraits : 'TUnrestEnumerating classTrait',
	#instVars : [
		'offset',
		'limit'
	],
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
UnrestAnotherTestEndpoint class >> endpointPath [
	^ Path / 'another-test'
]

{ #category : #accessing }
UnrestAnotherTestEndpoint >> cursor [
	^ UnrestTestCursor new
		offset: offset;
		total: limit * 2.5;
		yourself
]

{ #category : #enumerating }
UnrestAnotherTestEndpoint >> enumerateWith: aCursor [
	| response result contents |

	offset := aCursor offset.
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
UnrestAnotherTestEndpoint >> initialize [
	super initialize.
	limit := 2.
	offset := 0
]

{ #category : #accessing }
UnrestAnotherTestEndpoint >> limit [
	^ limit
]

{ #category : #accessing }
UnrestAnotherTestEndpoint >> limit: anObject [
	limit := anObject
]

{ #category : #accessing }
UnrestAnotherTestEndpoint >> offset [
	^ offset
]

{ #category : #accessing }
UnrestAnotherTestEndpoint >> offset: anObject [
	offset := anObject
]

{ #category : #tests }
UnrestAnotherTestEndpoint >> test [
	<endpoint>
	<get>
	^ self execute
]