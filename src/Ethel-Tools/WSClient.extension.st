Extension { #name : #WSClient }

{ #category : #'*Ethel-Tools' }
WSClient >> buildMapOn: aBuilder [
	| map |

	map := WSMap onClient: self.
	map buildMapOn: aBuilder
]

{ #category : #'*Ethel-Tools' }
WSClient >> buildMapOnOld: aBuilder [
	| map path |

	map := ((self class pathReferences groupedBy: [ :each | each value ])
		sorted: [ :a :b | a key pathString < b key pathString ])
		asDictionary.

	map
		keysAndValuesDo: [ :aPath :impls | 
			(aPath withParents copyWithout: aPath)
				do: [ :parent | map at: parent ifAbsentPut: (Set with: self / parent) ] ].
	map at: Path root put: self.
	
	aBuilder shape circle
		size: 15;
		color: [ Color transparent ];
		borderColor: [ :impls | 
			| defaultColor methodColor |

			methodColor := Color colorFrom: '#4682B4'.
			defaultColor := Color gray.
			(impls size = 1 and: [ impls anyOne == self ])
				ifTrue: [ defaultColor ]
				ifFalse: [ impls
						detect: [ :anImpl | anImpl isMethod and: [ anImpl isWSEndpointMethod ] ]
						ifFound: [ methodColor ]
						ifNone: [ defaultColor ] ] ];
		borderWidth: 2.
	aBuilder
		explore: self
		using: [ :anImpl | 
			anImpl == self
				ifTrue: [ map associations
						select: [ :each | each key size = 1 ]
						thenCollect: #value ]
				ifFalse: [ path := anImpl isWSEndpoint
						ifTrue: [ anImpl endpointPath ]
						ifFalse: [ anImpl wsEndpointPath ].
					map associations
						select: [ :assoc | 
							assoc key segments size = (path segments size + 1)
								and: [ assoc key segments beginsWith: path segments ] ]
						thenCollect: #value ] ].
	aBuilder rightward.
	aBuilder gap: 120 @ 0.
	aBuilder labelShape
		color: Color lightGray;
		text: [ :anImpl | 
			| aPath |

			aPath := map keyAtValue: anImpl.
			aPath isRoot
				ifTrue: [ self baseUrl ]
				ifFalse: [ aPath segments last ] ].
	aBuilder lineShape color: Color gray.
	aBuilder build
]

{ #category : #'*Ethel-Tools' }
WSClient >> buildTopologyOn: aBuilder [
	| endpointClasses colors allHttpMethods lb |

	endpointClasses := (self class endpoints flatCollect: [ :each | each withAllSuperclasses ]) select: #isWSEndpoint.

	allHttpMethods := self class supportedHttpMethods
		collect: #asLowercase.

	colors := RTColorPalette qualitative
		colors: allHttpMethods size
		scheme: 'Dark2'.

	aBuilder methodShape
		color:
			[ :method | colors at: (allHttpMethods indexOf: method wsEndpointHttpMethod) ].
	aBuilder
		classname: #name;
		instanceVariables: #instVarNames;
		methodsNames: [ :cls | cls methods select: #isWSEndpointExecutionMethod ];
		methodselector: [ :aMethod | 
			'{1} ~> {2}'
				format:
					{aMethod selector.
					aMethod wsEndpointPath pathString } ];
		attributeselector: #yourself;
		superclass: #superclass.
	aBuilder addObjects: endpointClasses.
	aBuilder layout tree.

	lb := RTLegendBuilder new.
	lb view: aBuilder view.
	lb left.
	lb
		nestDo: [ :n :e :g | 
			n
				padding: 10;
				on: e nest: g;
				resizeWithoutRecursion: e for: g ].

	lb backgroundShape
		box;
		borderColor: Color white;
		color: Color transparent;
		borderWidth: 2.

	allHttpMethods
		withIndexDo:
			[ :aMethod :i | lb addColoredText: aMethod asString color: (colors at: i) ].
	lb build
]

{ #category : #'*Ethel-Tools' }
WSClient >> gtDerivedEndpointClassesIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite list
		title: [ 'Endpoint classes' translated ];
		beMultiple;
		allowsSearch;
		display: [ self class endpoints ];
		when: [ self class endpoints isEmptyOrNil not ]
]

{ #category : #'*Ethel-Tools' }
WSClient >> gtMapIn: aComposite [
	<gtInspectorPresentationOrder: 11>
	^ aComposite roassal2
		title: ['Map' translated];
		initializeView: [ RTInteractiveTreeBuilder new ];
		painting: [ :view | self buildMapOn: view ]
]

{ #category : #'*Ethel-Tools' }
WSClient >> gtTopologyIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite roassal2
		title: ['Topology' translated];
		initializeView: [ RTUMLClassBuilder new ];
		painting: [ :view | self buildTopologyOn: view ]
]
