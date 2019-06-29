"
I am a pluggable cursor and I am used by ==WSPluggableEndpoint== to handle enumeration.

I hold arbitrary data in #data ivar - think of this as your store of things like offset and limit, or page number and page size values. This data can be accessed and modified during enumeration.

Set #hasMore to false when enumereation process should stop.

See class notes on ==WSPluggableEndpoint== for more information.

Instance Variables
	data:		<Object>
	hasMore:		<Boolean>
"
Class {
	#name : #WSPluggableCursor,
	#superclass : #Object,
	#traits : 'TWSEnumerationCursor',
	#classTraits : 'TWSEnumerationCursor classTrait',
	#instVars : [
		'data',
		'hasMore'
	],
	#category : #'Ethel-Core'
}

{ #category : #accessing }
WSPluggableCursor >> at: key [
	^ data at: key ifAbsent: nil
]

{ #category : #accessing }
WSPluggableCursor >> at: key ifAbsentPut: value [
	^ data at: key ifAbsentPut: value
]

{ #category : #accessing }
WSPluggableCursor >> at: key put: value [
	^ data at: key put: value
]

{ #category : #enumerating }
WSPluggableCursor >> hasMore [
	^ hasMore
]

{ #category : #accessing }
WSPluggableCursor >> hasMore: anObject [
	hasMore := anObject
]

{ #category : #initialization }
WSPluggableCursor >> initialize [
	super initialize.
	hasMore := true.
	data := Dictionary new
]

{ #category : #accessing }
WSPluggableCursor >> remove: key [
	data remove: key ifAbsent: [  ]
]
