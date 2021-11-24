Class {
	#name : #EthelMapCalypso,
	#superclass : #RSBaselineCalypso,
	#category : #'Ethel-Tools-Calypso'
}

{ #category : #asserting }
EthelMapCalypso class >> shouldBeActivatedInContext: aBrowserContext [
	^ aBrowserContext isClassSelected and: [ 
		  aBrowserContext lastSelectedClass inheritsFrom: WSClient ]
]

{ #category : #adding }
EthelMapCalypso >> addEdgesOn: canvas [
	RSLineBuilder line
		canvas: canvas;
		border: self border;
		connectToAll: [:model | model wsEndpointReferences ].
]

{ #category : #building }
EthelMapCalypso >> addMethodsOn: canvas [
	| shape popup |

	popup := RSPopup new.
	popup shapeBuilder: [ :aMethod | self labelForMethod: aMethod ].

	canvas addAll:
		(self executingMethods collect: [ :aMethod | 
			 shape := self shapeFor: aMethod.
			 shape model: aMethod.
			 shape @ popup.
			 shape ])
]

{ #category : #building }
EthelMapCalypso >> addMissingPathsOn: canvas [
	| map |

	map := canvas shapes groupedBy: [ :aShape | 
		       aShape model wsEndpointPath ].
	map keysDo: [ :aPath | 
		| p |
		p := aPath.
		[ 
		p := p parent.
		p isRoot ] whileFalse: [ 
			map at: p put: p.
			canvas addShape: (self shapeForTransientPath: p) ] ]
]

{ #category : #building }
EthelMapCalypso >> applyLayoutOn: canvas [
	| layout |

	layout := RSTreeLayout on: canvas shapes.
	canvas when: RSExtentChangedEvent do: [ :evt | 
		canvas newAnimation
			duration: 2 seconds;
			onStepDo: [ canvas zoomToFit ] ]
]

{ #category : #building }
EthelMapCalypso >> buildUmlCanvas [
	| canvas |

	canvas := RSCanvas new.
	self addMethodsOn: canvas.
	"self addMissingPathsOn: canvas."
	"self addEdgesOn: canvas."
	self applyLayoutOn: canvas.
	"self applyControlsOn: canvas."
	self applyTheme: canvas.
	"self buildMenuOn: canvas."
	"self buildLegendOn: canvas."
	^ canvas
]

{ #category : #initialization }
EthelMapCalypso >> defaultIconName [
	^ #objects
]

{ #category : #accessing }
EthelMapCalypso >> defaultTitle [
	^'Map'
]

{ #category : #building }
EthelMapCalypso >> descriptionForMethod: aMethod [
	| str |

	str := '' writeStream.
	aMethod wsEndpointAccessor ifNotNil: [ :accessor | 
		str
			nextPutAll: accessor method;
			nextPutAll: ' ';
			nextPutAll:
				(accessor path
					 ifNil: [ '' ]
					 ifNotNil: [ :aPath | aPath pathString ]);
			nextPut: Character lf ].
	str nextPutAll:
		'#' , aMethod methodClass name , '>>' , aMethod selector.
	^ str contents
]

{ #category : #building }
EthelMapCalypso >> executingMethods [
	^ self targetClass endpoints flatCollect: #wsEndpointExecutingMethods
]

{ #category : #hooks }
EthelMapCalypso >> isEnumeratedEndpointClass: anEndpointClass [
	^ (anEndpointClass inheritsFrom: WSPluggableEndpoint) not and: [ 
		  anEndpointClass traitComposition includesTrait:
			  TWSEnumeration class ]
]

{ #category : #building }
EthelMapCalypso >> labelForMethod: aMethod [
	| label r group bg labelElement |

	r := 10.
	labelElement := RSShapeBuilder multiline
		          fontSize: self theme labelFont pointSize + 2;
		          color: self theme textColor;
		          elementOn: (self descriptionForMethod: aMethod).
	labelElement matrix clearTranslation.
	label := labelElement shape.

	bg := RSBox new
		      color: (self theme backgroundColor alpha: 0.88);
		      size: label width + (r * 2) @ label height + 4;
		      cornerRadius: r;
		      yourself.

	group := RSGroup new
		         add: bg;
		         add: label;
		         yourself.
	^ group asShape
]

{ #category : #hooks }
EthelMapCalypso >> shapeFor: method [
	| shape |

	shape := RSEllipse new
		         border: self border;
		         @ self highlightable;
		         model: method;
		         size: 15;
		         yourself.
	shape
		when: RSMouseDoubleClick
		do: [ :evt | evt shape model browse ].
	method ifNotNil: [ :cls | 
		method methodClass = self targetClass name ifTrue: [ 
			shape color: Color blue ] ].
	^ shape
]

{ #category : #hooks }
EthelMapCalypso >> shapeForTransientPath: path [
	^ RSEllipse new
		  border: self border;
		  @ self highlightable;
		  model: path;
		  size: 15;
		  yourself
]
