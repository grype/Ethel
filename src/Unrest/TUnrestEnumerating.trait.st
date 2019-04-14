"
I encapsulate generic behavior of an enumerating endpoint.

I provide a collection-like interface to an endpoint. This is often useful when dealing with paginating endpoints.

Example:
	
""Define paging cursor to track page number and generate accesors for the two ivars. #hasMore is used by ==TUnrestEnumerating== to determine whether there are anymore requests to make. We'll be setting that ivar ourselves when we handle responses""

Object subclass: #PagingCursor
	uses: TUnrestEnumerationCursor 
	instanceVariableNames: 'page hasMore'
	classVariableNames: ''
	package: 'MyPackage'
	
""Define simple search endpoint and accessors for all its ivars, so that we can configure the endpoint as appropriate...""

Object subclass: #SearchEndpoint
	uses: TUnrestEndpoint + TUnrestEnumerating
	instanceVariableNames: 'query limit page pageSize'
	classVariableNames: ''
	package: 'MyPackage'
	
""Following ==TUnrestEnumerating== create and return new cursor via #cursor, and a single enumerating request via #enumerateWith:limit:""

SearchEndpoint>>cursor
	^ PagingCursor new
	
SearchEndpoint>>enumerateWith: aCursor limit: anInt
	| results |
	page := aCursor page.
	anInt ifNotNil: [ :val | pageSize := val ].
	results := self execute. 	""Assuming #execute returns a lits of results""
	aCursor page: aCursor page + 1.
	aCursor hasMore: (results isNotNil and: [ results size == pageSize ]).
	^ results

Now we can enumerate search results like a collection:

ep := (SearchEndpoint on: client) query: 'something'; limit: 100; yourself.
ep do: [ :each | Transcript crLog: each asString ].
ep collect: [ :each | Something from: each ].
ep detect: [ :each | each includesSubstring: 'something' ] ifFound: [ :found | Transcript crLog: found ].
ep reject: [ :each | each endsWith: 'er' ].
ep collect: #yourself.
etc...
"
Trait {
	#name : #TUnrestEnumerating,
	#category : #'Unrest-Core'
}

{ #category : #enumerating }
TUnrestEnumerating >> collect: aBlock [
	^ self collect: aBlock as: OrderedCollection 
]

{ #category : #enumerating }
TUnrestEnumerating >> collect: aBlock as: aClass [
	| result cursor |

	result := aClass new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | result addAll: (val collect: aBlock) ] ].
	^ result
]

{ #category : #enumerating }
TUnrestEnumerating >> collect: aBlock into: aCollection [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | aCollection fillFrom: val with: aBlock ] ].
	^ aCollection
]

{ #category : #accessing }
TUnrestEnumerating >> cursor [
	^ self subclassResponsibility
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock [ 
	^ self detect: aBlock ifNone: [ self errorNotFound: aBlock ]
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock ifFound: foundBlock [
	^ self detect: aBlock ifFound: foundBlock ifNone: [ nil ]
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock ifFound: foundBlock ifNone: noneBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :values | values detect: aBlock ifFound: [ :val | ^ foundBlock cull: val ] ifNone: [  ] ] ].
	^ noneBlock value
]

{ #category : #enumerating }
TUnrestEnumerating >> detect: aBlock ifNone: exceptionBlock [
	^ self detect: aBlock ifFound: [ :val | val ] ifNone: exceptionBlock 
]

{ #category : #enumerating }
TUnrestEnumerating >> do: aBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ] whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | val do: aBlock ] ]
]

{ #category : #enumerating }
TUnrestEnumerating >> do: aBlock separatedBy: separatorBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | val do: aBlock separatedBy: separatorBlock ] ]
]

{ #category : #enumerating }
TUnrestEnumerating >> enumerateWith: aCursor [
	^ self enumerateWith: aCursor limit: nil
]

{ #category : #enumerating }
TUnrestEnumerating >> enumerateWith: aCursor limit: anInt [
	^ self subclassResponsibility
]

{ #category : #'error handling' }
TUnrestEnumerating >> errorNotFound: anObject [
	"Raise a NotFound exception."

	NotFound signalFor: anObject
]

{ #category : #enumerating }
TUnrestEnumerating >> first [
	^ (self first: 1) ifNotNil: [ :values | values first ]
]

{ #category : #enumerating }
TUnrestEnumerating >> first: aLimit [
	^ self enumerateWith: self cursor limit: aLimit
]

{ #category : #enumerating }
TUnrestEnumerating >> groupedBy: aBlock [
	| cursor groups |

	groups := PluggableDictionary integerDictionary.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | 
					val
						do:
							[ :each | (groups at: (aBlock value: each) ifAbsentPut: [ OrderedCollection new ]) add: each ] ] ].
	^ groups
]

{ #category : #enumerating }
TUnrestEnumerating >> groupedBy: aBlock having: aSelectionBlock [
	^ (self groupedBy: aBlock) select: aSelectionBlock
]

{ #category : #enumerating }
TUnrestEnumerating >> inject: thisValue into: binaryBlock [
	| cursor nextValue |

	nextValue := thisValue.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | val do: [ :each | nextValue := binaryBlock value: nextValue value: each ] ] ].
	^ nextValue
]

{ #category : #enumerating }
TUnrestEnumerating >> next: anInt with: aCursor [
	^ self enumerateWith: aCursor limit: anInt
]

{ #category : #enumerating }
TUnrestEnumerating >> nextWith: aCursor [
	^ self enumerateWith: aCursor
]

{ #category : #enumerating }
TUnrestEnumerating >> reject: aBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val reject: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].

	^ result
]

{ #category : #enumerating }
TUnrestEnumerating >> select: aBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val select: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].
	^ result
]

{ #category : #enumerating }
TUnrestEnumerating >> select: selectBlock thenCollect: collectBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val select: selectBlock thenCollect: collectBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].
	^ result
]
