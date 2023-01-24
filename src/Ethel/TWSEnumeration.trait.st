"
I encapsulate generic behavior of an enumerating endpoint and provide a collection-like interface to it.

I work together with a cursor object. Before starting enumeration, I create a cursor by sending #cursor. I then pass that cursor object to #next:with: as I enumerate the endpoint. After each enumeration, I check if the cursor object #hasMore before continuing.

Example:

[[[
			""Define paging cursor - we'll track current page number via #page ivar, and set #hasMore ivar when finished""
			
			Object subclass: #PagingCursor
				uses: TWSEnumerationCursor 
				instanceVariableNames: 'page hasMore'
				classVariableNames: ''
				package: 'MyPackage'
			
			""Define simple search endpoint""
			
			Object subclass: #SearchEndpoint
			uses: TWSEndpoint + TWSEnumeration
			instanceVariableNames: 'query limit page pageSize'
			classVariableNames: ''
			package: 'MyPackage'
			
			""Return new cursor via #cursor""
			
			SearchEndpoint>>cursor
				^ PagingCursor new
			
			""Define single-step method for enumeration. Notice how we use aCursor to configure the endpoint and how we update the cursor after the execution""
			
			SearchEndpoint>>next: aLimit with: aCursor
				| results |
				page := aCursor page.
				aLimit ifNotNil: [ :val | pageSize := val ].
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
			ep collect: [ :each | Something from: each ] max: 100.
			ep detect: [ :each | each includesSubstring: 'something' ] ifFound: [ :found | Transcript crLog: found ].
			ep reject: [ :each | each endsWith: 'er' ].
			ep collect: #yourself.
			ep flatCollect: [ :each | each at: #files ].
			ep do: [ :each | self doSomethingWith: each ] separatedBy: [ self doSeparator ] until: [ self isComplete ].
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
	| result |

	result := aClass new.
	self enumerate: [ :val | result addAll: (val collect: aBlock) ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock as: aClass max: aLimit [
	| result |

	result := aClass new.
	self
		enumerate: [ :val | 
			result addAll: (val collect: aBlock).
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock into: aCollection [
	self enumerate: [ :val | aCollection fillFrom: val with: aBlock ].
	^ aCollection
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock into: aCollection until: untilBlock [
	self
		enumerate: [ :val | 
			aCollection fillFrom: val with: aBlock.
			untilBlock value
				ifTrue: [ ^ self ] ].
	^ aCollection
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock max: aLimit [
	^ self collect: aBlock as: OrderedCollection max: aLimit
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock max: aLimit thenDo: doBlock [
	^ (self collect: collectBlock max: aLimit) do: doBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock max: aLimit thenReject: selectBlock [
	^ (self collect: collectBlock max: aLimit) reject: selectBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock max: aLimit thenSelect: selectBlock [
	^ (self collect: collectBlock max: aLimit) select: selectBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock thenDo: doBlock [
	^ (self collect: collectBlock) do: doBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock thenReject: selectBlock [
	^ (self collect: collectBlock) reject: selectBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock thenSelect: selectBlock [
	^ (self collect: collectBlock) select: selectBlock
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
	self
		enumerate: [ :values | 
			values
				detect: aBlock
				ifFound: [ :val | ^ foundBlock cull: val ]
				ifNone: [  ] ].
	^ noneBlock value
]

{ #category : #enumerating }
TWSEnumeration >> detect: aBlock ifNone: exceptionBlock [
	^ self detect: aBlock ifFound: [ :val | val ] ifNone: exceptionBlock 
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock [
	self enumerate: [ :val | val do: aBlock ]
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock separatedBy: separatorBlock [
	self enumerate: [ :val | val do: aBlock separatedBy: separatorBlock ]
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock separatedBy: separatorBlock until: untilBlock [
	self
		enumerate: [ :val | 
			val do: aBlock separatedBy: separatorBlock.
			untilBlock value
				ifTrue: [ ^ self ] ]
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock until: untilBlock [
	self
		enumerate: [ :val | 
			val do: aBlock.
			untilBlock value
				ifTrue: [ ^ self ] ]
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock [ 
	self enumerate: aBlock with: self cursor
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock limit: aLimit [
	self enumerate: aBlock with: self cursor limit: aLimit
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock with: aCursor [
	[ aCursor hasMore ]
		whileTrue: [ (self nextWith: aCursor) ifNotNil: aBlock ]
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock with: aCursor limit: aLimit [
	[ aCursor hasMore ]
		whileTrue: [ (self next: aLimit with: aCursor) ifNotNil: aBlock ]
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

	| results cursor |
	cursor := self cursor.
	results := OrderedCollection new.
	[ results size < aLimit and: [ cursor hasMore ] ] whileTrue: [ 
		| newResults |
		newResults := self next: aLimit - results size with: cursor.
		newResults isEmptyOrNil ifTrue: [ ^ results ].
		results addAll: newResults ].
	^ results
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock [
	^ self flatCollect: aBlock as: OrderedCollection 
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock as: aClass [
	| result |

	result := aClass new.
	self enumerate: [ :val | result addAll: (val flatCollect: aBlock) ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock as: aClass max: aLimit [
	| result |

	result := aClass new.
	self
		enumerate: [ :val | 
			result addAll: (val flatCollect: aBlock).
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock max: aLimit [
	^ self flatCollect: aBlock as: OrderedCollection max: aLimit
]

{ #category : #enumerating }
TWSEnumeration >> groupedBy: aBlock [
	| groups |

	groups := PluggableDictionary integerDictionary.
	self
		enumerate: [ :val | 
			val
				do: [ :each | 
					(groups
						at: (aBlock value: each)
						ifAbsentPut: [ OrderedCollection new ]) add: each ] ].
	^ groups
]

{ #category : #enumerating }
TWSEnumeration >> groupedBy: aBlock having: aSelectionBlock [
	^ (self groupedBy: aBlock) select: aSelectionBlock
]

{ #category : #enumerating }
TWSEnumeration >> inject: thisValue into: binaryBlock [
	| nextValue |

	nextValue := thisValue.
	self
		enumerate: [ :val | 
			val
				do: [ :each | nextValue := binaryBlock value: nextValue value: each ] ].

	^ nextValue
]

{ #category : #enumerating }
TWSEnumeration >> next: anInt with: aCursor [
	^ self subclassResponsibility
]

{ #category : #enumerating }
TWSEnumeration >> nextWith: aCursor [
	^ self next: nil with: aCursor
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate:
			[ :val | (val reject: aBlock) ifNotNil: [ :selected | result addAll: selected ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock max: aLimit [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			(val reject: aBlock) ifNotNil: [ :selected | result addAll: selected ].
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenCollect: collectBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			(val reject: aBlock thenCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ] ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenCollect: collectBlock max: aLimit [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			(val reject: aBlock thenCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ].
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenDo: doBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			(val reject: aBlock thenDo: doBlock)
				ifNotNil: [ :selected | result addAll: selected ] ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenDo: doBlock until: untilBlock [
	self
		enumerate: [ :val | 
			val reject: aBlock thenDo: doBlock.
			untilBlock value
				ifTrue: [ ^ self ] ]
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenFlatCollect: collectBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			((val reject: aBlock) flatCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ] ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenFlatCollect: collectBlock max: aLimit [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			((val reject: aBlock) flatCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ].
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate:
			[ :val | (val select: aBlock) ifNotNil: [ :selected | result addAll: selected ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock max: aLimit [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			(val select: aBlock) ifNotNil: [ :selected | result addAll: selected ].
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ]
		limit: aLimit.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenCollect: collectBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			(val select: selectBlock thenCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ] ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenCollect: collectBlock max: aLimit [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			(val select: selectBlock thenCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ].
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ]
		limit: aLimit.

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenDo: doBlock [
	self enumerate: [ :val | val select: selectBlock thenDo: doBlock ]
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenDo: doBlock until: untilBlock [
	self
		enumerate: [ :val | 
			val select: selectBlock thenDo: doBlock.
			untilBlock value
				ifTrue: [ ^ self ] ]
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenFlatCollect: collectBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			((val select: selectBlock) flatCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ] ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenFlatCollect: collectBlock max: aLimit [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :val | 
			((val select: selectBlock) flatCollect: collectBlock)
				ifNotNil: [ :selected | result addAll: selected ].
			result size >= aLimit
				ifTrue: [ ^ result first: aLimit ] ].
	^ result
]
