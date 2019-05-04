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
TGHPagingEndpoint >> maxPageSize [
	^ 100
]

{ #category : #enumerating }
TGHPagingEndpoint >> next: aLimit with: aCursor [
	| result |

	page := aCursor page.
	pageSize := (aLimit ifNil: [ aCursor pageSize ])
		min: self maxPageSize.
	result := self nextPage.
	(result isNotNil and: [ result size >= pageSize ])
		ifTrue: [ aCursor advance ]
		ifFalse: [ aCursor hasMore: false ].
	^ result
]

{ #category : #enumerating }
TGHPagingEndpoint >> nextPage [
	^ self subclassResponsibility
]
