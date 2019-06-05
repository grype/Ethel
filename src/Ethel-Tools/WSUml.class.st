Class {
	#name : #WSUml,
	#superclass : #Object,
	#instVars : [
		'client',
		'httpMethods',
		'colors',
		'objects',
		'typePalette'
	],
	#category : #'Ethel-Tools'
}

{ #category : #'as yet unclassified' }
WSUml class >> onClient: aClient [
	^ self basicNew initializeWithClient: aClient
]

{ #category : #building }
WSUml >> boxColorFor: cls [
	| types color pallete |
	types := self distinguishedTypes.
	color := Color white.
	pallete := self typePalette.
	types
		detect: [ :each | 
			(cls includesBehavior: each)
				or: [ cls traitComposition includesTrait: each ] ]
		ifFound: [ :found | color := pallete at: (types indexOf: found) ]
		ifNone: [  ].
	^ color
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

	aBuilder classNameShape color: [ :cls | self colorForClassName: cls ].

	aBuilder boxShape color: [ :cls | self boxColorFor: cls ].

	aBuilder
		classname: [ :each | self classNameFor: each ];
		instanceVariables: [ :cls | self instanceVariablesFor: cls ];
		methodsNames: [ :cls | self methodNamesFor: cls ];
		methodselector: [ :aMethod | self selectorForMethod: aMethod ];
		attributeselector: #yourself;
		superclass: #superclass.

	aBuilder addObjects: self objects.
	aBuilder layout tree verticalGap: 40; horizontalGap: 30.
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
WSUml >> colorForClassName: aClass [
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
				colors: self httpMethods size
				scheme: 'Dark2' ]
]

{ #category : #building }
WSUml >> distinguishedTypes [
	^ {WSClient.
	TWSEnumeration.
	TWSEnumerationCursor}
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

{ #category : #building }
WSUml >> instanceVariablesFor: cls [
	^ cls package = WSClient package
		ifTrue: [ {} ]
		ifFalse: [ cls instVarNames ]
]

{ #category : #building }
WSUml >> methodNamesFor: cls [
	(cls package = WSClient package) ifTrue: [ ^ {  } ].
	^ cls methods reject: #isFromTrait.
"	(cls traitComposition includesTrait: TWSEnumerationCursor) ifTrue: [ ^ cls methods ].
	^ cls methods select: #isWSEndpointExecutionMethod"
]

{ #category : #accessing }
WSUml >> objects [
	| traits |
	^ objects
		ifNil: [ objects := Set with: client class.
			((client class endpoints
				flatCollect: [ :each | each withAllSuperclasses ])
				select: #isWSEndpoint) ifNotEmpty: [ :val | objects addAll: val ].

			traits := objects
				flatCollect: [ :each | each traitComposition allTraits ].
			objects addAll: traits.
			objects
				addAll:
					((traits flatCollect: #referencedClasses)
						select: [ :each | 
							each isWSEndpoint
								or: [ each traitComposition includesTrait: TWSEnumerationCursor ] ]).
			^ objects ]
]

{ #category : #building }
WSUml >> selectorForMethod: aMethod [
	[aMethod wsEndpointPath ifNil: [ ^ aMethod selector ]] on: Error do: [^ aMethod selector ].
	^ '{1} ~> {2}'
		format:
			{aMethod selector.
			aMethod wsEndpointPath pathString}
]

{ #category : #building }
WSUml >> typePalette [
	^ typePalette
		ifNil: [ typePalette := (RTColorPalette qualitative
				colors: self distinguishedTypes size)
				collect: [ :each | 
					| result |
					result := each.
					[ result lightness < 0.9 ] whileTrue: [ result := result paler ].
					result ] ]
]
