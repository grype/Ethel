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
	^ self basicNew initWithClient: aClient
]

{ #category : #accessing }
WSMap >> associations [
	^ map associations
]

{ #category : #building }
WSMap >> buildMap [
	map := client class pathReferences
		groupedBy: [ :each | each value ]
		affect: [ :impls | impls collect: #key ].

	map at: Path root put: client.
	map
		keysAndValuesDo: [ :aPath :impls | 
			(aPath withParents copyWithout: aPath)
				do: [ :parent | map at: parent ifAbsentPut: client / parent ] ].
	^ map
]

{ #category : #building }
WSMap >> buildMapOn: aBuilder [
	self buildMap.
	aBuilder
		rightward;
		gap: 120 @ 0.

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
			obj == client
				ifTrue: [ map associationsSelect: [ :each | each key segments size = 1 ] ]
				ifFalse: [ | thisPath |

					thisPath := map keyAtValue: obj.
					map
						associationsSelect: [ :each | 
							each key segments size = (thisPath segments size + 1)
								and: [ each key segments beginsWith: thisPath segments ] ] ] ].

	aBuilder build
]

{ #category : #accessing }
WSMap >> client [
	^ client
]

{ #category : #initialization }
WSMap >> initWithClient: aClient [
	self initialize.
	client := aClient
]
