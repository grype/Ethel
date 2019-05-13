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

{ #category : #'as yet unclassified' }
WSMap >> buildMap [
	map := (client class pathReferences
		groupedBy: [ :each | each value ]
		affect: [ :impls | WSMapItem with: (impls collect: #key) ])
		asDictionary.

	map
		keysAndValuesDo: [ :aPath :impls | 
			(aPath withParents copyWithout: aPath)
				do:
					[ :parent | map at: parent ifAbsentPut: (WSMapItem with: client / parent) ] ].
	map at: Path root put: (WSMapItem with: client).
	^ map
]

{ #category : #'as yet unclassified' }
WSMap >> buildMapOn: aBuilder [
	self buildMap.
	self configureOn: aBuilder.

	aBuilder
		explore: (map at: Path root) implementors
		using: [ :impls | 
			| path |

			path := map keyAtValue: (WSMapItem with: impls).
			map associations
				select: [ :each | 
					each key segments size = (path segments size + 1)
						and: [ path isRoot or: [ each key segments beginsWith: path segments ] ] ]
				thenCollect: [ :each | each value implementors ] ].

	aBuilder build
]

{ #category : #'as yet unclassified' }
WSMap >> configureOn: aBuilder [
	aBuilder
		rightward;
		gap: 120 @ 0.

	aBuilder shape circle
		size: 15;
		color: [ Color transparent ];
		borderColor: [ :impls | 
			(WSMapItem with: impls) containsExecutingMethod
				ifTrue: [ self methodNodeColor ]
				ifFalse: [ self transientNodeColor ] ];
		borderWidth: 2.

	aBuilder labelShape
		color: Color lightGray;
		text: [ :impls | 
			| aPath |

			aPath := map keyAtValue: (WSMapItem with: impls).
			aPath isRoot
				ifTrue: [ client baseUrl ]
				ifFalse: [ aPath segments last ] ].

	aBuilder lineShape color: self lineColor
]

{ #category : #'as yet unclassified' }
WSMap >> initWithClient: aClient [
	self initialize.
	client := aClient
]

{ #category : #'as yet unclassified' }
WSMap >> lineColor [ 
	^ Color gray
]

{ #category : #'as yet unclassified' }
WSMap >> methodNodeColor [
	^ Color colorFrom: '#4682B4'
]

{ #category : #'as yet unclassified' }
WSMap >> transientNodeColor [
	^ Color gray
]
