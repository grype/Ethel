Trait {
	#name : #TGHPagingEndpoint,
	#instVars : [
		'page',
		'pageSize'
	],
	#traits : 'TWSEnumeration',
	#classTraits : 'TWSEnumeration classTrait',
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #configuring }
TGHPagingEndpoint >> configurePaginationOn: http [
	http queryAt: #page put: page.
	http queryAt: #per_page put: pageSize
]

{ #category : #accessing }
TGHPagingEndpoint >> cursor [
	^ GHPagingCursor new
]

{ #category : #enumerating }
TGHPagingEndpoint >> enumerateStep [
	^ self subclassResponsibility
]

{ #category : #enumerating }
TGHPagingEndpoint >> enumerateWith: aCursor limit: aLimit [
	| result |

	page := aCursor page.
	pageSize := aCursor pageSize.
	aLimit ifNotNil: [ :val | pageSize := aLimit ].
	result := self enumerateStep.
	(result isNotNil and: [ result size >= pageSize ])
		ifTrue: [ aCursor advance ]
		ifFalse: [ aCursor hasMore: false ].
	^ result
]
