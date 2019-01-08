Extension { #name : #Unrest }

{ #category : #'*Unrest-Tools' }
Unrest >> allReferencingPaths [
	^ ((self class associatedEndpointClasses reject: #isAbstractEndpoint)
		flatCollect: [ :aCls | aCls referencingPaths ]) asSet
		flatCollect: [ :aPath | 
			| p result |

			result := Set with: aPath.
			p := aPath parent.
			[ p isRoot ]
				whileFalse: [ result add: p.
					p := p parent ].
			result ]
]

{ #category : #'*Unrest-Tools' }
Unrest >> buildMapOn: aBuilder [
	| paths |

	paths := self allReferencingPaths sorted: [ :a :b | a pathString < b pathString ].

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
Unrest >> buildTopologyOn: aBuilder [
	| endpoints colors allHttpMethods |

	endpoints := self class associatedEndpointClasses.
	allHttpMethods := self allowedHttpMethods collect: #asLowercase.

	colors := RTColorPalette qualitative colors: allHttpMethods size scheme: 'Set2'.
	aBuilder methodShape
		color: [ :method | 
			((method pragmas collect: [ :p | p keyword asLowercase asSymbol ])
				intersection: self allowedHttpMethods)
				ifEmpty: [ nil ]
				ifNotEmpty:
					[ :foundPragmaMethods | colors at: (allHttpMethods indexOf: foundPragmaMethods first asLowercase) ] ].

	aBuilder
		addObjects: endpoints;
		classname: #name;
		instanceVariables: #instVarNames;
		methodsNames: [ :cls | 
			cls methods
				select:
					[ :aMethod | (aMethod pragmas collect: #keyword) includesAny: TUnrestEndpoint endpointPragmas ] ];
		methodselector: [ :aMethod | 
			'{1} ~> {2}'
				format:
					{aMethod selector.
					((aMethod pragmaAt: #endpoint:)
						ifNil: [ aMethod methodClass endpointPath pathString ]
						ifNotNil: [ :p | (aMethod methodClass endpointPath / p arguments first) pathString ])} ];
		attributeselector: #yourself;
		superclass: #superclass.

	aBuilder treeLayout.
	aBuilder build
]

{ #category : #'*Unrest-Tools' }
Unrest >> gtMapIn: aComposite [
	<gtInspectorPresentationOrder: 11>
	^ aComposite roassal2
		title: ['Map' translated];
		initializeView: [ RTInteractiveTreeBuilder new ];
		painting: [ :view | self buildMapOn: view ]
]

{ #category : #'*Unrest-Tools' }
Unrest >> gtTopologyIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite roassal2
		title: ['Topology' translated];
		initializeView: [ RTUMLClassBuilder new ];
		painting: [ :view | self buildTopologyOn: view ]
]
