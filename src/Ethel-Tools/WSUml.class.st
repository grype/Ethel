Class {
	#name : #WSUml,
	#superclass : #Object,
	#instVars : [
		'httpMethods',
		'colors',
		'objects',
		'typePalette',
		'selectedObject'
	],
	#category : #'Ethel-Tools-UML'
}

{ #category : #'instance creation' }
WSUml class >> onClient: aClient [
	^ self basicNew initializeWithClient: aClient
]

{ #category : #'instance creation' }
WSUml class >> onEndpoint: anEndpoint [
	^ self onEndpointClass: anEndpoint class
]

{ #category : #'instance creation' }
WSUml class >> onEndpointClass: anEndpointClass [
	^ self basicNew initializeWithEndpointClass: anEndpointClass
]

{ #category : #building }
WSUml >> additionaInteractions [
	^ {self showAllReferencesInteraction}
]

{ #category : #building }
WSUml >> boxColorFor: cls [
	(selectedObject isNotNil and: [ cls = selectedObject ])
		ifTrue: [ ^ Color white ].
	cls package = WSClient package
		ifTrue: [ ^ Color white alpha: 0.9 ].
	(cls inheritsFrom: WSClient)
		ifTrue: [ ^ Color
				r: 0.642
				g: 0.87
				b: 0.976
				alpha: 1.0 ].
	cls isTrait
		ifTrue: [ ^ Color
				r: 0.866
				g: 0.905
				b: 0.78
				alpha: 1.0 ].
	^ Color white alpha: 0.8
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
	self httpMethods isEmptyOrNil
		ifFalse: [ self buildLegendOn: aBuilder ]
]

{ #category : #building }
WSUml >> buildUMLOn: aBuilder [
	aBuilder methodShape
		color: [ :method | self colorForHttpMethod: method ].

	aBuilder classNameShape color: [ :cls | self colorForClassName: cls ].
	aBuilder boxShape color: [ :cls | self boxColorFor: cls ].

	aBuilder
		classname: [ :each | self classNameFor: each ];
		instanceVariables: [ :cls | self instanceVariablesFor: cls ];
		methodsNames: [ :cls | self methodNamesFor: cls ];
		methodselector: [ :aMethod | self selectorForMethod: aMethod ];
		attributeselector: #yourself;
		superclass: #superclass.

	aBuilder addObjects: objects.
	aBuilder layout tree
		verticalGap: 40;
		horizontalGap: 30.
	self additionaInteractions
		do: [ :each | aBuilder interaction addInteraction: each ]
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
WSUml >> colorForClassName: aClass [
	(selectedObject isNotNil and: [ aClass = selectedObject ])
		ifTrue: [ ^ Color red ].
	^ aClass package = WSClient package
		ifTrue: [ Color gray lighter ]
		ifFalse: [ Color gray darker ]
]

{ #category : #accessing }
WSUml >> colorForHttpMethod: anHttpMethod [
	(anHttpMethod wsEndpointHttpMethod isNotNil
		and: [ self httpMethods includes: anHttpMethod wsEndpointHttpMethod ])
		ifFalse: [ ^ Color gray ].
	^ self colors
		at: (self httpMethods indexOf: anHttpMethod wsEndpointHttpMethod)
]

{ #category : #accessing }
WSUml >> colors [
	^ colors
		ifNil: [ colors := RTColorPalette qualitative
				colors: (4 max: self httpMethods size)
				scheme: 'Dark2' ]
]

{ #category : #building }
WSUml >> elementsReferencedBy: element [
	^ element view elements
		select: [ :each | self isElement: each referencedBy: element ]
]

{ #category : #building }
WSUml >> elementsReferencing: element [
	^ element view elements
		select: [ :el | self isElement: element referencedBy: el ]
]

{ #category : #initialization }
WSUml >> extendWithTraits [
	| traits |
	traits := objects
		flatCollect: [ :each | each traitComposition allTraits ].
	objects addAll: traits.
	objects
		addAll:
			((traits flatCollect: #referencedClasses)
				select: [ :each | 
					each isWSEndpoint
						or: [ each traitComposition includesTrait: TWSEnumerationCursor ] ])
]

{ #category : #accessing }
WSUml >> httpMethods [
	^ httpMethods
		ifNil: [ | methods |
			methods := objects flatCollect: [ :each | each methods ].
			httpMethods := (methods
				select: [ :each | each isWSEndpointExecutionMethod ]
				thenCollect: [ :each | each wsEndpointHttpMethod asLowercase ])
				asSet asOrderedCollection ]
]

{ #category : #initialization }
WSUml >> initializeWithClient: aClient [
	self initialize.
	objects := Set with: aClient class.
	((aClient class endpoints
		flatCollect: [ :each | each withAllSuperclasses ])
		select: #isWSEndpoint) ifNotEmpty: [ :val | objects addAll: val ].
	self extendWithTraits
]

{ #category : #initialization }
WSUml >> initializeWithEndpointClass: anEndpointClass [
	self initialize.
	objects := Set new
		add: anEndpointClass;
		addAll: anEndpointClass allSubclasses;
		addAll: (anEndpointClass allSuperclasses select: #isWSEndpoint);
		addAll:
			(Object allSubclasses
				select: [ :cls | 
					cls isWSEndpoint
						and: [ cls referencedClasses includes: anEndpointClass ] ]);
		yourself.
	objects
		addAll: (anEndpointClass referencedClasses select: #isWSEndpoint).
	self extendWithTraits
]

{ #category : #building }
WSUml >> instanceVariablesFor: cls [
	^ cls package = WSClient package
		ifTrue: [ {} ]
		ifFalse: [ cls instVarNames sorted: [ :a :b | a < b ] ]
]

{ #category : #testing }
WSUml >> isElement: element referencedBy: referencingElement [
	((referencingElement shape isKindOf: RTBox)
		and: [ element shape isKindOf: RTBox ])
		ifFalse: [ ^ false ].
	(element model isNil or: [ referencingElement model isNil ])
		ifTrue: [ ^ false ].
	((referencingElement model respondsTo: #referencedClasses)
		and: [ referencingElement model referencedClasses includes: element model ])
		ifTrue: [ ^ true ].
	(referencingElement model isTrait
		and: [ element model isClass
				and: [ element model traitComposition
						includesTrait: referencingElement model ] ])
		ifTrue: [ ^ true ].
	^ false
]

{ #category : #building }
WSUml >> lineFromElement: anObject [
	^ RTArrowedLine new
		color: (Color colorFrom: '#82B446');
		attachPoint: RTShorterDistanceAttachPoint new;
		inverted;
		yourself
]

{ #category : #building }
WSUml >> lineToElement: element [
	^ RTArrowedLine new
		color: (Color colorFrom: '#4682B4');
		attachPoint: RTShorterDistanceAttachPoint new;
		yourself
]

{ #category : #building }
WSUml >> methodNamesFor: cls [
	cls package = WSClient package
		ifTrue: [ ^ {} ].
	^ (cls methods reject: #isFromTrait) sorted: [ :a :b | a selector < b selector ]
]

{ #category : #accessing }
WSUml >> objects: anObject [
	objects := anObject
]

{ #category : #accessing }
WSUml >> selectedObject [
	^ selectedObject
]

{ #category : #accessing }
WSUml >> selectedObject: anObject [
	selectedObject := anObject
]

{ #category : #building }
WSUml >> selectorForMethod: aMethod [
	[aMethod wsEndpointPath ifNil: [ ^ aMethod selector ]] on: Error do: [^ aMethod selector ].
	^ '{1} ~> {2}'
		format:
			{aMethod selector.
			aMethod wsEndpointPath pathString}
]

{ #category : #interactions }
WSUml >> showAllReferencesInteraction [
	^ WSShowEdges new
		toShape: [ :element | self lineToElement: element ];
		fromShape: [ :element | self lineFromElement: element ];
		connectFromElements: [ :element | self elementsReferencing: element ];
		connectToElements: [ :element | self elementsReferencedBy: element ]
]
