Class {
	#name : #WSMap,
	#superclass : #Object,
	#instVars : [
		'client',
		'map'
	],
	#category : #'Ethel-Tools-Map'
}

{ #category : #'as yet unclassified' }
WSMap class >> onClient: aClient [
	^ self basicNew initializeWithClient: aClient
]

{ #category : #accessing }
WSMap >> associations [
	^ map associations
]

{ #category : #building }
WSMap >> buildMap [
	map := (client class pathReferences groupedBy: [ :each | each value ])
		associationsDo: [ :each | each value: (each value collect: #key) ].

	map at: Path root put: client.
	map
		keysAndValuesDo: [ :aPath :impls | 
			(aPath withParents copyWithout: aPath)
				do: [ :parent | map at: parent ifAbsentPut: client / parent ] ].
	^ map
]

{ #category : #building }
WSMap >> buildMapOn: aBuilder [
	| maxSegmentSize gap |

	self buildMap.
	maxSegmentSize := (map keys flatCollect: #segments) ifEmpty: [ 0 ] ifNotEmpty: [ :segments | (segments collect: #size) max ].
	gap := ((120 max: maxSegmentSize * 8) min: 220) @ 0.
	aBuilder
		rightward;
		gap: gap.

	aBuilder shape circle
		size: 15;
		color: [ :obj | (WSMapItem with: obj forMap: self) shapeColor ];
		borderColor: [ :obj | (WSMapItem with: obj forMap: self) shapeBorderColor ];
		borderWidth: 2.

	aBuilder labelShape
		color: [ Smalltalk ui theme textColor ];
		text: [ :obj | (WSMapItem with: obj forMap: self) description ].

	aBuilder lineShape color: [ Smalltalk ui theme ghostTextColor ].

	aBuilder
		explore: client
		using: [ :obj | 
			| children |

			children := obj == client
				ifTrue: [ map associationsSelect: [ :each | each key segments size = 1 ] ]
				ifFalse: [ | thisPath |

					thisPath := map keyAtValue: obj.
					map
						associationsSelect: [ :each | 
							each key segments size = (thisPath segments size + 1)
								and: [ each key segments beginsWith: thisPath segments ] ] ].
			OrderedDictionary
				newFrom: (children associations sorted: [ :a :b | a key <= b key ]) ].

	aBuilder elements
		do: [ :e | 
			e removeInteractionIfPresent: RTPopup.
			e @ (RTPopup new text: [ :item | self popupTextFor: item ]) ].
	aBuilder build
]

{ #category : #accessing }
WSMap >> client [
	^ client
]

{ #category : #initialization }
WSMap >> initializeWithClient: aClient [
	self initialize.
	client := aClient
]

{ #category : #building }
WSMap >> popupTextFor: item [
	item isCollection
		ifFalse: [ ^ item ].
	^ (item
		collect: [ :each | 
			each isCompiledMethod
				ifTrue: [ each printString ]
				ifFalse: [ each asString ] ]) asOrderedCollection
		joinUsing: Character cr
]
