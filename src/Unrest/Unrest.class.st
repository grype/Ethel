Class {
	#name : #Unrest,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'contentReader',
		'contentWriter'
	],
	#category : #Unrest
}

{ #category : #introspection }
Unrest class >> associatedEndpointClasses [
	| methods referencedClasses rootEndpointClass |

	methods := self endpointMethods.
	referencedClasses := ((methods flatCollect: [ :each | each value ])
		collect: #value) asSet.
	rootEndpointClass := (referencedClasses
		flatCollect: [ :each | each withAllSuperclasses ])
		select: [ :each | each superclass == UnrestEndpoint ].
	^ (rootEndpointClass flatCollect: #withAllSubclasses)
		reject: [ :each | each isAbstract ]
]

{ #category : #introspection }
Unrest class >> endpointMethods [
	^ self endpointMethodsOn: self
]

{ #category : #introspection }
Unrest class >> endpointMethodsOn: aClass [
	^ (aClass methods
		collect: [ :aMethod | 
			aMethod
				->
					(aMethod allLiterals
						select: [ :aLiteral | aLiteral value isClass and: [ aLiteral value inheritsFrom: UnrestEndpoint ] ]) ])
		select: [ :each | each value isNotEmpty ]
]

{ #category : #'instance creation' }
Unrest class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #endpoints }
Unrest >> / aString [
	"Creates a new generic endpoint."
	^ (UnrestPluggableEndpoint on: self) path: (Path / aString); yourself
]

{ #category : #endpoints }
Unrest >> > endPointClass [
	"Creates a new endpoint of specified class."
	^ endPointClass on: self
]

{ #category : #http }
Unrest >> allowedHttpMethods [
	^ #(#get #post #put #patch #delete #options)
]

{ #category : #accessing }
Unrest >> baseUrl [
	^ baseUrl
]

{ #category : #http }
Unrest >> configureHttpClient: http [
	contentReader ifNotNil: [ :val | http contentReader: val ].
	contentWriter ifNotNil: [ :val | http contentWriter: val ]
]

{ #category : #accessing }
Unrest >> contentReader [
	^ contentReader
]

{ #category : #accessing }
Unrest >> contentReader: anObject [
	contentReader := anObject
]

{ #category : #accessing }
Unrest >> contentWriter [
	^ contentWriter
]

{ #category : #accessing }
Unrest >> contentWriter: anObject [
	contentWriter := anObject
]

{ #category : #http }
Unrest >> createHttpClient [
	| client |
	client := ZnClient new.
	self configureHttpClient: client.
	^ client
]

{ #category : #execution }
Unrest >> execute [
	| sender |
	sender := thisContext sender.
	(sender methodClass inheritsFrom: UnrestEndpoint) ifFalse: [ UnrestError signal: ('Cannot be executed by {1} because it is not an UnrestEndpoint!' format: { sender class greaseString}) ].
	self execute: sender
]

{ #category : #execution }
Unrest >> execute: anEndpoint [
	| http result |

	http := self createHttpClient.
	anEndpoint configureOn: http.
	self validateRequest: http request.
	result := http execute.
	self validateResponse: http response.
	^ result
]

{ #category : #'gt-inspector-extension' }
Unrest >> gtMapIn: aComposite [
	<gtInspectorPresentationOrder: 11>
	^ aComposite roassal2
		title: ['Map' translated];
		initializeView: [ RTInteractiveTreeBuilder new ];
		painting: [ :view | self viewMapOn: view ]
]

{ #category : #'gt-inspector-extension' }
Unrest >> gtTopologyIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite roassal2
		title: ['Topology' translated];
		initializeView: [ RTUMLClassBuilder new ];
		painting: [ :view | self viewTopologyOn: view ]
]

{ #category : #initialization }
Unrest >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]

{ #category : #http }
Unrest >> validateMethod: aMethod [
	| method |
	method := aMethod asLowercase.
	^ (self allowedHttpMethods includes: method)
		ifTrue: [ method asSymbol ]
		ifFalse:
			[ UnrestError signal: ('Tried to perform invalid Method "{1}"' format: {aMethod}) ]
]

{ #category : #http }
Unrest >> validateRequest: aRequest [
	(aRequest method isNotNil and: [ aRequest url isNotNil ]) ifFalse: [ UnrestError signal: 'Invalid HTTP Request' ]
]

{ #category : #http }
Unrest >> validateResponse: aResponse [
	aResponse isSuccess
		ifTrue: [ ^ true ].
	UnrestError
		signal:
			('{1}: {2}'
				format:
					{aResponse statusLine code.
					aResponse statusLine reason}).
	^ false
]

{ #category : #visualization }
Unrest >> viewMapOn: aBuilder [
	| paths |
	
	paths := (self class associatedEndpointClasses flatCollect: [ :aCls | aCls referencingPaths ]) asSet
		flatCollect: [ :aPath | 
			| p result |

			result := Set with: aPath.
			p := aPath parent.
			[ p isRoot ]
				whileFalse: [ result add: p.
					p := p parent ].
			result ].		
	paths := paths sorted: [ :a :b | a pathString < b pathString ].
	
	aBuilder view canvas color: (Color colorFrom: '#EEE').
	aBuilder
		explore: Path root
		using: [ :aPath | 
			aPath isRoot
				ifTrue: [ paths select: [ :each | each size = 1 ] ]
				ifFalse: [ paths
						select: [ :each | each segments size = (aPath segments size + 1) and: [ each segments beginsWith: aPath segments ] ] ] ].
	aBuilder rightward.
	aBuilder gap: 120 @ 0.
	aBuilder labelShape
		text: [ :aPath | 
			aPath isRoot
				ifTrue: [ self baseUrl ]
				ifFalse: [ aPath segments last ] ].
	aBuilder build.
	^ aBuilder view
]

{ #category : #visualization }
Unrest >> viewTopologyOn: aBuilder [
	| endpoints colors allHttpMethods |

	endpoints := PlaidClient associatedEndpointClasses.
	allHttpMethods := self allowedHttpMethods collect: #asLowercase.
	colors := RTColorPalette qualitative colors: allHttpMethods size scheme: 'Set2'.
	aBuilder methodShape
		color: [ :method | 
			((method pragmas collect: [ :p | p keyword asLowercase asSymbol ]) intersection: self allowedHttpMethods)
				ifEmpty: [ nil ]
				ifNotEmpty: [ :foundPragmaMethods | colors at: (allHttpMethods indexOf: foundPragmaMethods first asLowercase) ] ].

	aBuilder
		addObjects: endpoints;
		"classname: [ :cls | cls endpointPath pathString];"
		classname: [ :cls | cls name ];
		instanceVariables: #instVarNames;
		methodsNames: [ :cls | 
			cls methods
				select: [ :aMethod | (aMethod pragmas collect: #keyword) includesAny: UnrestEndpoint endpointPragmas ] ];
		methodselector: [ :aMethod | 
			| str |

			str := '' writeStream.
			str nextPutAll: aMethod selector.
			(aMethod pragmaAt: #endpoint:) ifNotNil: [ :p | str nextPutAll: (' ~> /{1}' format: {p arguments first}) ].
			str contents ];
		attributeselector: #yourself;
		superclass: [ :cls | 
			cls endpointPath parent isRoot
				ifTrue: [ nil ]
				ifFalse: [ endpoints detect: [ :each | each endpointPath = cls endpointPath parent ] ifNone: [ nil ] ] ].

	aBuilder treeLayout
]
