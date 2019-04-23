Extension { #name : #WSClient }

{ #category : #'*Unrest-Tools' }
WSClient >> buildMapOn: aBuilder [
	| paths |

	paths := (self class pathReferences collect: #value) sorted: [ :a :b | a pathString < b pathString ].

	aBuilder view canvas color: (Color colorFrom: '#EEE').
	aBuilder
		explore: Path root
		using: [ :aPath | 
			aPath isRoot
				ifTrue: [ paths select: [ :each | each size = 1 ] ]
				ifFalse: [ paths
						select: [ :each | 
							each segments size = (aPath segments size + 1)
								and: [ each segments beginsWith: aPath segments ] ] ] ].
	aBuilder rightward.
	aBuilder gap: 120 @ 0.
	aBuilder labelShape
		text: [ :aPath | 
			aPath isRoot
				ifTrue: [ self baseUrl ]
				ifFalse: [ aPath segments last ] ].
	aBuilder build
]

{ #category : #'*Unrest-Tools' }
WSClient >> buildTopologyOn: aBuilder [
	| endpoints colors allHttpMethods lb |

	endpoints := self class derivedWSEndpoints.

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
					aMethod wsEndpointPath} ];
		attributeselector: #yourself;
		superclass: #superclass.
	aBuilder addObjects: endpoints.
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

{ #category : #'*Unrest-Tools' }
WSClient >> gtDerivedEndpointClassesIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite list
		title: [ 'Endpoint classes' translated ];
		beMultiple;
		allowsSearch;
		display: [ self class derivedWSEndpoints ];
		when: [ self class derivedWSEndpoints isEmptyOrNil not ]
]

{ #category : #'*Unrest-Tools' }
WSClient >> gtMapIn: aComposite [
	<gtInspectorPresentationOrder: 11>
	^ aComposite roassal2
		title: ['Map' translated];
		initializeView: [ RTInteractiveTreeBuilder new ];
		painting: [ :view | self buildMapOn: view ]
]

{ #category : #'*Unrest-Tools' }
WSClient >> gtTopologyIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite roassal2
		title: ['Topology' translated];
		initializeView: [ RTUMLClassBuilder new ];
		painting: [ :view | self buildTopologyOn: view ]
]
