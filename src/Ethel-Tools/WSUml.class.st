Class {
	#name : #WSUml,
	#superclass : #Object,
	#instVars : [
		'client',
		'httpMethods',
		'colors'
	],
	#category : #'Ethel-Tools'
}

{ #category : #'as yet unclassified' }
WSUml class >> onClient: aClient [
	^ self basicNew initializeWithClient: aClient
]

{ #category : #building }
WSUml >> buildLegendOn: aBuilder [
	| lb |
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
	self httpMethods
		withIndexDo:
			[ :aMethod :i | lb addColoredText: aMethod asString color: (self colors at: i) ].
	lb build
]

{ #category : #building }
WSUml >> buildOn: aBuilder [
	self buildUMLOn: aBuilder.
	self buildLegendOn: aBuilder
]

{ #category : #building }
WSUml >> buildUMLOn: aBuilder [
	aBuilder methodShape
		color: [ :method | self colorForHttpMethod: method ].

	aBuilder
		classname: [ :each | self classNameFor: each ];
		instanceVariables: #instVarNames;
		methodsNames: [ :cls | cls methods select: #isWSEndpointExecutionMethod ];
		methodselector: [ :aMethod | self selectorForMethod: aMethod ];
		attributeselector: #yourself;
		superclass: #superclass.

	aBuilder addObjects: self objects.
	aBuilder layout tree
]

{ #category : #accessing }
WSUml >> classNameFor: anObject [
	^ anObject name
		,
			((anObject traitComposition includesTrait: TWSEnumeration)
				ifTrue: [ '*' ]
				ifFalse: [ '' ])
]

{ #category : #accessing }
WSUml >> client [
	^ client
]

{ #category : #accessing }
WSUml >> client: anObject [
	client := anObject
]

{ #category : #accessing }
WSUml >> colorForHttpMethod: anHttpMethod [
	^ self colors
		at: (self httpMethods indexOf: anHttpMethod wsEndpointHttpMethod)
]

{ #category : #accessing }
WSUml >> colors [
	^ colors
		ifNil: [ colors := RTColorPalette qualitative
				colors: self httpMethods size
				scheme: 'Dark2' ]
]

{ #category : #accessing }
WSUml >> httpMethods [
	^ httpMethods
		ifNil: [ httpMethods := client class supportedHttpMethods
				collect: #asLowercase ]
]

{ #category : #initialization }
WSUml >> initializeWithClient: aClient [
	self initialize.
	client := aClient
]

{ #category : #accessing }
WSUml >> objects [
	| allObjects traits |
	allObjects := Set with: client class.
	((client class endpoints
		flatCollect: [ :each | each withAllSuperclasses ])
		select: #isWSEndpoint) ifNotEmpty: [ :val | allObjects addAll: val ].

	traits := allObjects
		flatCollect: [ :each | each traitComposition allTraits ].
	allObjects addAll: traits.
	allObjects
		addAll:
			((traits flatCollect: #referencedClasses)
				select: [ :each | 
					each isWSEndpoint
						or: [ each traitComposition includesTrait: TWSEnumerationCursor ] ]).
	^ allObjects
]

{ #category : #building }
WSUml >> selectorForMethod: aMethod [
	^ '{1} ~> {2}'
		format:
			{aMethod selector.
			aMethod wsEndpointPath pathString}
]
