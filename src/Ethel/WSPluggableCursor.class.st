"
I am a pluggable cursor and I am used by ==WSPluggableEndpoint== to handle enumeration.

I hold arbitrary data in #data ivar - this of this as your store of things like offset and limit, or page number and page size values. This data can be accessed and modified during enumeration.

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
WSPluggableCursor >> data [
	^ data
]

{ #category : #accessing }
WSPluggableCursor >> data: anObject [
	data := anObject
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
