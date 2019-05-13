Class {
	#name : #WSMap,
	#superclass : #Object,
	#instVars : [
		'client',
		'map'
	],
	#category : #'Ethel-Core'
}

{ #category : #'as yet unclassified' }
WSMap class >> onClient: aClient [
	^ self basicNew initWithClient: aClient
]

{ #category : #accessing }
WSMap >> associations [
	^ map associations
]

{ #category : #'as yet unclassified' }
WSMap >> buildMap [
	map := (client class pathReferences
		groupedBy: [ :each | each value / each key selector ]
		affect: [ :impls | impls collect: #key ]) asDictionary.

	client class endpoints
		do:
			[ :each | (map at: each endpointPath ifAbsentPut: Set new) add: each ].

	map
		keysAndValuesDo: [ :aPath :impls | 
			(aPath withParents copyWithout: aPath)
				do: [ :parent | map at: parent ifAbsentPut: client / parent ] ].
	map at: Path root put: client.
	^ map
]

{ #category : #'as yet unclassified' }
WSMap >> buildMapOn: aBuilder [
	self buildMap.
	aBuilder
		rightward;
		gap: 120 @ 0.

	aBuilder shape circle
		size: 15;
		color: [ :obj | (WSMapItem with: obj map: self) shapeColor ];
		borderColor: [ :obj | (WSMapItem with: obj map: self) shapeBorderColor ];
		borderWidth: 2.

	aBuilder labelShape
		color: Color lightGray;
		text: [ :obj | (WSMapItem with: obj map: self) description ].

	aBuilder lineShape color: Color gray.

	aBuilder
		explore: client
		using: [ :obj | (WSMapItem with: obj map: self) children ].

	aBuilder build
]

{ #category : #accessing }
WSMap >> client [
	^ client
]

{ #category : #'as yet unclassified' }
WSMap >> initWithClient: aClient [
	self initialize.
	client := aClient
]
