Class {
	#name : #GHPagingCursor,
	#superclass : #Object,
	#traits : 'TWSEnumerationCursor',
	#classTraits : 'TWSEnumerationCursor classTrait',
	#instVars : [
		'page',
		'pageSize',
		'hasMore'
	],
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #private }
GHPagingCursor class >> large [
	^ self new
		pageSize: 200;
		yourself
]

{ #category : #private }
GHPagingCursor class >> medium [
	^ self new
		pageSize: 100;
		yourself
]

{ #category : #private }
GHPagingCursor class >> small [
	^ self new
		pageSize: 10;
		yourself
]

{ #category : #accessing }
GHPagingCursor >> advance [
	page := page + 1
]

{ #category : #enumerating }
GHPagingCursor >> hasMore [
	^ hasMore
]

{ #category : #accessing }
GHPagingCursor >> hasMore: anObject [
	hasMore := anObject
]

{ #category : #initialization }
GHPagingCursor >> initialize [
	super initialize.
	page := 1.
	pageSize := 10.
	hasMore := true
]

{ #category : #accessing }
GHPagingCursor >> page [
	^ page
]

{ #category : #accessing }
GHPagingCursor >> page: anObject [
	page := anObject
]

{ #category : #accessing }
GHPagingCursor >> pageSize [
	^ pageSize
]

{ #category : #accessing }
GHPagingCursor >> pageSize: anObject [
	pageSize := anObject
]
