Trait {
	#name : #TGHPagingEndpoint,
	#instVars : [
		'page',
		'pageSize'
	],
	#traits : 'TGHEndpoint + TWSEnumeration',
	#classTraits : 'TGHEndpoint classTrait + TWSEnumeration classTrait',
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #configuring }
TGHPagingEndpoint >> configurePaginationOn: http [

	page ifNotNil: [ :val | http queryAt: #page put: val ].
	pageSize ifNotNil: [ :val | http queryAt: #per_page put: val ]
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
TGHPagingEndpoint >> nextPage [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
TGHPagingEndpoint >> nextWith: aCursor [
	| result |

	page := aCursor page.
	pageSize := aCursor pageSize min: self maxPageSize.
	result := self nextPage.
	(result isNotNil and: [ result size >= pageSize ])
		ifTrue: [ aCursor advance ]
		ifFalse: [ aCursor hasMore: false ].
	^ result
]
