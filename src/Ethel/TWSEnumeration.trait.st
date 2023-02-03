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
	self enumerate: [ :aSlice | result addAll: (aSlice collect: aBlock) ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock as: aClass max: aLimit [
	| count |

	self
		deprecated: 'Use #collect:as:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	^ self
		  collect: [ :each | 
			  count := count + 1.
			  aBlock value: each ]
		  as: aClass
		  whileTrue: [ count < aLimit ]
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock as: aClass whileFalse: whileBlock [
	| result |

	result := aClass new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice collect: aBlock) ]
		with: self cursor
		whileFalse: whileBlock.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock as: aClass whileTrue: whileBlock [
	| result |

	result := aClass new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice collect: aBlock) ]
		with: self cursor
		whileTrue: whileBlock.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock into: aCollection [
	self enumerate: [ :aSlice | aCollection fillFrom: aSlice with: aBlock ].
	^ aCollection
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock into: aCollection until: untilBlock [
	self
		deprecated: 'Use #collect:into:whileFalse: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	self
		enumerate: [ :val | 
			aCollection fillFrom: val with: aBlock.
			(untilBlock cull: val) ifTrue: [ ^ self ] ]
		with: self cursor
		whileFalse: untilBlock.
	^ aCollection
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock into: aCollection whileFalse: aWhileBlock [
	self
		enumerate: [ :aSlice | aCollection fillFrom: aSlice with: aBlock ]
		with: self cursor
		whileFalse: aWhileBlock.
	^ aCollection
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock into: aCollection whileTrue: aWhileBlock [
	self
		enumerate: [ :aSlice | aCollection fillFrom: aSlice with: aBlock ]
		with: self cursor
		whileTrue: aWhileBlock.
	^ aCollection
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock max: aLimit [
	self
		deprecated: 'Use #collect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	^ self collect: aBlock as: OrderedCollection max: aLimit
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock max: aLimit thenDo: doBlock [
	self
		deprecated: 'Use #collect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
		
	^ (self collect: collectBlock max: aLimit) do: doBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock max: aLimit thenReject: selectBlock [
	self
		deprecated: 'Use #collect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	^ (self collect: collectBlock max: aLimit) reject: selectBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: collectBlock max: aLimit thenSelect: selectBlock [
	self
		deprecated: 'Use #collect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
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

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock whileFalse: aWhileBlock [
	^ self collect: aBlock as: OrderedCollection whileFalse: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> collect: aBlock whileTrue: aWhileBlock [
	^ self collect: aBlock as: OrderedCollection whileTrue: aWhileBlock
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
	self enumerate: [ :aSlice | 
		aSlice
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
	self enumerate: [ :aSlice | aSlice do: aBlock ]
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock separatedBy: separatorBlock [
	| ticked |

	ticked := false.
	self enumerate: [ :aSlice | 
		ticked ifTrue: [ separatorBlock value ].
		aSlice do: aBlock separatedBy: separatorBlock.
		ticked := true ]
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock separatedBy: separatorBlock until: untilBlock [
	self
		deprecated: 'Use #do:separatedBy:whileFalse: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	self do: aBlock separatedBy: separatorBlock whileFalse: untilBlock
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock separatedBy: separatorBlock whileFalse: aWhileBlock [
	| ticked |

	ticked := false.
	self
		enumerate: [ :aSlice | 
			ticked ifTrue: [ separatorBlock value ].
			aSlice do: aBlock separatedBy: separatorBlock.
			ticked := true ]
		with: self cursor
		whileFalse: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock separatedBy: separatorBlock whileTrue: aWhileBlock [
	| ticked |

	ticked := false.
	self
		enumerate: [ :aSlice | 
			ticked ifTrue: [ separatorBlock value ].
			aSlice do: aBlock separatedBy: separatorBlock.
			ticked := true ]
		with: self cursor
		whileTrue: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock until: untilBlock [
	self
		deprecated: 'Use #do:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	^ self do: aBlock whileFalse: untilBlock
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock whileFalse: aWhileBlock [
	self
		enumerate: [ :val | val do: aBlock ]
		with: self cursor
		whileFalse: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> do: aBlock whileTrue: aWhileBlock [
	self
		enumerate: [ :val | val do: aBlock ]
		with: self cursor
		whileTrue: aWhileBlock
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock [ 
	self enumerate: aBlock with: self cursor
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock with: aCursor [
	[ aCursor hasMore ]
		whileTrue: [ (self nextWith: aCursor) ifNotNil: aBlock ]
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock with: aCursor whileFalse: aWhileBlock [
	[ aCursor hasMore and: [ aWhileBlock value not ] ] whileTrue: [ 
		(self nextWith: aCursor) ifNotNil: aBlock ]
]

{ #category : #'private - enumerating' }
TWSEnumeration >> enumerate: aBlock with: aCursor whileTrue: aWhileBlock [
	[ aCursor hasMore and: [ aWhileBlock value ] ] whileTrue: [ 
		(self nextWith: aCursor) ifNotNil: aBlock ]
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
	| results |

	results := OrderedCollection new.
	self
		enumerate: [ :aSlice | results addAll: aSlice ]
		with: self cursor
		whileTrue: [ results size < aLimit ].
	^ results first: (aLimit min: results size)
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
	| result count |

	self
		deprecated: 'Use #flatCollect:as:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	result := self
		          flatCollect: [ :aValue | 
			          count := count + 1.
			          aBlock value: aValue ]
		          as: aClass
		          whileTrue: [ count < aLimit ].
	^ result first: (result size min: aLimit)
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock as: aClass whileFalse: aWhileBlock [
	| result |

	result := aClass new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice flatCollect: aBlock) ]
		with: self cursor
		whileFalse: aWhileBlock.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock as: aClass whileTrue: aWhileBlock [
	| result |

	result := aClass new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice flatCollect: aBlock) ]
		with: self cursor
		whileTrue: aWhileBlock.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock max: aLimit [
	self
		deprecated: 'Use #flatCollect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	^ self flatCollect: aBlock as: OrderedCollection max: aLimit
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock whileFalse: aWhileBlock [
	^ self
		  flatCollect: aBlock
		  as: OrderedCollection
		  whileFalse: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> flatCollect: aBlock whileTrue: aWhileBlock [
	^ self
		  flatCollect: aBlock
		  as: OrderedCollection
		  whileTrue: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> groupedBy: aBlock [
	| groups |

	groups := Dictionary new.
	self enumerate: [ :aSlice | 
		aSlice do: [ :each | 
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
TWSEnumeration >> groupedBy: aBlock whileFalse: aWhileBlock [
	| groups |

	groups := Dictionary new.
	self
		enumerate: [ :aSlice | 
			aSlice do: [ :each | 
				(groups
					 at: (aBlock value: each)
					 ifAbsentPut: [ OrderedCollection new ]) add: each ] ]
		with: self cursor
		whileFalse: aWhileBlock.
	^ groups
]

{ #category : #enumerating }
TWSEnumeration >> groupedBy: aBlock whileTrue: aWhileBlock [
	| groups |

	groups := Dictionary new.
	self
		enumerate: [ :aSlice | 
			aSlice do: [ :each | 
				(groups
					 at: (aBlock value: each)
					 ifAbsentPut: [ OrderedCollection new ]) add: each ] ]
		with: self cursor
		whileTrue: aWhileBlock.
	^ groups
]

{ #category : #enumerating }
TWSEnumeration >> inject: thisValue into: binaryBlock [
	| nextValue |

	nextValue := thisValue.
	self enumerate: [ :aSlice | 
		aSlice do: [ :each | 
			nextValue := binaryBlock value: nextValue value: each ] ].

	^ nextValue
]

{ #category : #enumerating }
TWSEnumeration >> inject: thisValue into: binaryBlock whileFalse: aWhileBlock [
	| nextValue |

	nextValue := thisValue.
	self
		enumerate: [ :aSlice | 
			aSlice do: [ :each | 
				nextValue := binaryBlock value: nextValue value: each ] ]
		with: self cursor
		whileFalse: aWhileBlock.

	^ nextValue
]

{ #category : #enumerating }
TWSEnumeration >> inject: thisValue into: binaryBlock whileTrue: aWhileBlock [
	| nextValue |

	nextValue := thisValue.
	self
		enumerate: [ :aSlice | 
			aSlice do: [ :each | 
				nextValue := binaryBlock value: nextValue value: each ] ]
		with: self cursor
		whileTrue: aWhileBlock.

	^ nextValue
]

{ #category : #enumerating }
TWSEnumeration >> nextWith: aCursor [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock [
	| result |

	result := OrderedCollection new.
	self enumerate: [ :aSlice | result addAll: (aSlice reject: aBlock) ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock max: aLimit [
	| result count |

	self
		deprecated: 'Use #reject:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	result := self
		          reject: [ :aValue | 
			          count := count + 1.
			          aBlock value: aValue ]
		          whileTrue: [ count < aLimit ].

	^ result first: (aLimit min: result size)
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenCollect: collectBlock [
	| result |

	result := OrderedCollection new.
	self enumerate: [ :aSlice | 
		result addAll: (aSlice reject: aBlock thenCollect: collectBlock) ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenCollect: collectBlock max: aLimit [
	| result count |

	self
		deprecated: 'Use #reject:thenCollect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	result := self
		          reject: [ :aValue | 
			          count := count + 1.
			          aBlock value: aValue ]
		          thenCollect: collectBlock
		          whileTrue: [ count < aLimit ].
	^ result first: (result size min: aLimit)
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenCollect: collectBlock whileFalse: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | 
			result addAll: (aSlice reject: aBlock thenCollect: collectBlock) ]
		with: self cursor
		whileFalse: aWhileBlock.

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenCollect: collectBlock whileTrue: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | 
			result addAll: (aSlice reject: aBlock thenCollect: collectBlock) ]
		with: self cursor
		whileTrue: aWhileBlock.

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenDo: doBlock [
	self enumerate: [ :aSlice | aSlice reject: aBlock thenDo: doBlock ]
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenDo: doBlock until: untilBlock [
	self
		deprecated: 'Use #reject:thenDo:whileFalse: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	^ self reject: aBlock thenDo: doBlock whileFalse: untilBlock
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenDo: doBlock whileFalse: aWhileBlock [
	self
		enumerate: [ :val | val reject: aBlock thenDo: doBlock ]
		with: self cursor
		whileFalse: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenDo: doBlock whileTrue: aWhileBlock [
	self
		enumerate: [ :val | val reject: aBlock thenDo: doBlock ]
		with: self cursor
		whileTrue: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenFlatCollect: collectBlock [
	| result |

	result := OrderedCollection new.
	self enumerate: [ :aSlice | 
		result addAll: ((aSlice reject: aBlock) flatCollect: collectBlock) ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenFlatCollect: collectBlock max: aLimit [
	| count result |

	self
		deprecated: 'Use #reject:thenFlatCollect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	result := self
		          reject: [ :aValue | 
			          count := count + 1.
			          aBlock value: aValue ]
		          thenFlatCollect: collectBlock
		          whileTrue: [ count < aLimit ].
	^ result first: (result size min: aLimit)
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenFlatCollect: collectBlock whileFalse: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | 
			result addAll: ((aSlice reject: aBlock) flatCollect: collectBlock) ]
		with: self cursor
		whileFalse: aWhileBlock.

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock thenFlatCollect: collectBlock whileTrue: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | 
			result addAll: ((aSlice reject: aBlock) flatCollect: collectBlock) ]
		with: self cursor
		whileTrue: aWhileBlock.

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock whileFalse: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice reject: aBlock) ]
		with: self cursor
		whileFalse: aWhileBlock.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> reject: aBlock whileTrue: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice reject: aBlock) ]
		with: self cursor
		whileTrue: aWhileBlock.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock [
	| result |

	result := OrderedCollection new.
	self enumerate: [ :aSlice | result addAll: (aSlice select: aBlock) ].
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock max: aLimit [
	| count result |

	self
		deprecated: 'Use #select:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	result := self
		          select: [ :aValue | 
			          count := count + 1.
			          aBlock value: aValue ]
		          whileTrue: [ count < aLimit ].
	^ result first: (result size min: aLimit)
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenCollect: collectBlock [
	| result |

	result := OrderedCollection new.
	self enumerate: [ :aSlice | 
		result addAll: (aSlice select: selectBlock thenCollect: collectBlock) ].

	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenCollect: collectBlock max: aLimit [
	| count result |

	self
		deprecated: 'Use #select:thenCollect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	result := self
		          select: [ :aValue | 
			          count := count + 1.
			          selectBlock value: aValue ]
		          whileTrue: [ count < aLimit ].
	result := result first: (result size min: aLimit).
	^ result collect: collectBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenCollect: collectBlock whileFalse: aWhileBlock [
	^ (self select: selectBlock whileFalse: aWhileBlock) collect:
		  collectBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenCollect: collectBlock whileTrue: aWhileBlock [
	^ (self select: selectBlock whileTrue: aWhileBlock) collect:
		  collectBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenDo: doBlock [
	self enumerate: [ :aSlice | aSlice select: selectBlock thenDo: doBlock ]
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenDo: doBlock until: untilBlock [
	self
		deprecated: 'Use #select:thenDo:whileFalse: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	^ self select: selectBlock thenDo: doBlock whileFalse: untilBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenDo: doBlock whileFalse: aWhileBlock [
	self
		enumerate: [ :aSlice | aSlice select: selectBlock thenDo: doBlock ]
		with: self cursor
		whileFalse: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenDo: doBlock whileTrue: aWhileBlock [
	self
		enumerate: [ :aSlice | aSlice select: selectBlock thenDo: doBlock ]
		with: self cursor
		whileTrue: aWhileBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenFlatCollect: collectBlock [
	^ (self select: selectBlock) collect: collectBlock 
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenFlatCollect: collectBlock max: aLimit [
	| result count |

	self
		deprecated: 'Use #select:thenFlatCollect:whileTrue: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.

	count := 0.
	result := self
		          select: [ :aValue | 
			          count := count + 1.
			          selectBlock value: aValue ]
		          thenFlatCollect: collectBlock
		          whileTrue: [ count < aLimit ].
	^ result first: (result size min: aLimit)
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenFlatCollect: collectBlock whileFalse: aWhileBlock [
	^ (self select: selectBlock whileFalse: aWhileBlock) flatCollect:
		  collectBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: selectBlock thenFlatCollect: collectBlock whileTrue: aWhileBlock [
	^ (self select: selectBlock whileTrue: aWhileBlock) flatCollect:
		  collectBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock until: untilBlock [
	self
		deprecated: 'Use #select:whileFalse: instead'
		on: '2 February 2023'
		in:
		'Pharo-10.0.0+build.536.sha.2314c3f457171dcde477ff6575b578835f1fd519 (64 Bit)'.
	^ self select: aBlock whileFalse: untilBlock
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock whileFalse: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice select: aBlock) ]
		with: self cursor
		whileFalse: aWhileBlock.
	^ result
]

{ #category : #enumerating }
TWSEnumeration >> select: aBlock whileTrue: aWhileBlock [
	| result |

	result := OrderedCollection new.
	self
		enumerate: [ :aSlice | result addAll: (aSlice select: aBlock) ]
		with: self cursor
		whileTrue: aWhileBlock.
	^ result
]
