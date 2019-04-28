"
I encapsulate generic behavior of an enumerating endpoint and provide a collection-like interface to an endpoint. This is often useful when dealing with paginating endpoints.

Example:

[[[

""Define paging cursor - we'll track current page number via #page ivar, and set #hasMore ivar to true when we detect end of results during enumeration""
			
			Object subclass: #PagingCursor
				uses: TUnrestEnumerationCursor 
				instanceVariableNames: 'page hasMore'
				classVariableNames: ''
				package: 'MyPackage'
			
""Define simple search endpoint""
			
			Object subclass: #SearchEndpoint
			uses: TUnrestEndpoint + TUnrestEnumerating
			instanceVariableNames: 'query limit page pageSize'
			classVariableNames: ''
			package: 'MyPackage'
			
""Return new cursor via #cursor""
			
			SearchEndpoint>>cursor
				^ PagingCursor new
			
""Enumeration is done inside #enumerateWith:limit:""
			
			SearchEndpoint>>enumerateWith: aCursor limit: anInt
				| results |
				page := aCursor page.
				anInt ifNotNil: [ :val | pageSize := val ].
				results := self execute. 	""Assuming #execute returns a lits of results""
				aCursor page: aCursor page + 1.  ""Increment page number""
				aCursor hasMore: (results isNotNil and: [ results size == pageSize ]).  ""Determine whether there's more results to fetch""
				^ results
]]]

Now we can enumerate search results like we would a collection:

[[[
			ep := (client / SearchEndpoint) query: 'something'; limit: 100; yourself.
			ep do: [ :each | Transcript crLog: each asString ].
			ep collect: [ :each | Something from: each ].
			ep detect: [ :each | each includesSubstring: 'something' ] ifFound: [ :found | Transcript crLog: found ].
			ep reject: [ :each | each endsWith: 'er' ].
			ep collect: #yourself.
]]]
"
Trait {
	#name : #TWSEnumeration,
	#category : #'Ethel-Core'
}

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock [
	^ self collect: aBlock as: OrderedCollection 
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock as: aClass [
	| result cursor |

	result := aClass new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | result addAll: (val collect: aBlock) ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock into: aCollection [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | aCollection fillFrom: val with: aBlock ] ].
	^ aCollection
]

{ #category : #accessing }
TWSEnumeration >> cursor [
	^ self subclassResponsibility
]

{ #category : #enumerating }
TWSEnumeration >> detect: aBlock [ 
	^ self detect: aBlock ifNone: [ self errorNotFound: aBlock ]
]

{ #category : #enumerating }
TWSEnumeration >> detect: aBlock ifFound: foundBlock [
	^ self detect: aBlock ifFound: foundBlock ifNone: [ nil ]
]

{ #category : #enumerating }
TWSEnumeration >> detect: aBlock ifFound: foundBlock ifNone: noneBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :values | values detect: aBlock ifFound: [ :val | ^ foundBlock cull: val ] ifNone: [  ] ] ].
	^ noneBlock value
]

{ #category : #enumerating }
TWSEnumeration >> detect: aBlock ifNone: exceptionBlock [
	^ self detect: aBlock ifFound: [ :val | val ] ifNone: exceptionBlock 
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ] whileTrue: [ (self enumerateWith: cursor) ifNotNil: [ :val | val do: aBlock ] ]
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock separatedBy: separatorBlock [
	| cursor |

	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | val do: aBlock separatedBy: separatorBlock ] ]
]

{ #category : #enumerating }
TWSEnumeration >> enumerateWith: aCursor [
	^ self enumerateWith: aCursor limit: nil
]

{ #category : #enumerating }
TWSEnumeration >> enumerateWith: aCursor limit: anInt [
	^ self subclassResponsibility
]

{ #category : #'error handling' }
TWSEnumeration >> errorNotFound: anObject [
	"Raise a NotFound exception."

	NotFound signalFor: anObject
]

{ #category : #enumerating }
TWSEnumeration >> first [
	^ (self first: 1) ifNotNil: [ :values | values first ]
]

{ #category : #enumerating }
TWSEnumeration >> first: aLimit [
	^ self enumerateWith: self cursor limit: aLimit
]

{ #category : #enumerating }
TWSEnumeration >> groupedBy: aBlock [
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
TWSEnumeration >> groupedBy: aBlock having: aSelectionBlock [
	^ (self groupedBy: aBlock) select: aSelectionBlock
]

{ #category : #enumerating }
TWSEnumeration >> inject: thisValue into: binaryBlock [
	| cursor nextValue |

	nextValue := thisValue.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | val do: [ :each | nextValue := binaryBlock value: nextValue value: each ] ] ].
	^ nextValue
]

{ #category : #enumerating }
TWSEnumeration >> next: anInt with: aCursor [
	^ self enumerateWith: aCursor limit: anInt
]

{ #category : #enumerating }
TWSEnumeration >> nextWith: aCursor [
	^ self enumerateWith: aCursor
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val reject: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val select: aBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenCollect: collectBlock [
	| result cursor |

	result := OrderedCollection new.
	cursor := self cursor.
	[ cursor hasMore ]
		whileTrue: [ (self enumerateWith: cursor)
				ifNotNil: [ :val | (val select: selectBlock thenCollect: collectBlock) ifNotNil: [ :selected | result addAll: selected ] ] ].
	^ result
]
