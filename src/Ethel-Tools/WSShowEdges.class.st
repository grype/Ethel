Class {
	#name : #WSShowEdges,
	#superclass : #RTInteraction,
	#instVars : [
		'connectToElements',
		'connectFromElements',
		'receiver',
		'toShape',
		'fromShape'
	],
	#classInstVars : [
		'lastHighlightedElements',
		'lastColor'
	],
	#category : #'Ethel-Tools-UML'
}

{ #category : #'reset shape' }
WSShowEdges class >> lastHighlightedElements [
	^ lastHighlightedElements
]

{ #category : #'reset shape' }
WSShowEdges class >> lastHighlightedElements: elements [
	lastHighlightedElements := elements
]

{ #category : #visitor }
WSShowEdges >> accept: aVisitor with: args [
	aVisitor visitShowEdgeInteraction: self with: args
]

{ #category : #accessing }
WSShowEdges >> color: aColorOrABlock [
	"Set the color of the edge to be added. The argument is a one-arg block, taking an association as argument, the key and value of the associations are model objects."
	self shape color: aColorOrABlock
]

{ #category : #accessing }
WSShowEdges >> colorElement: aColorOrABlock [
	"Set the color of the edge to be added. The argument is a one-arg block, taking an association as argument, the key and value of the associations are elements."
	self shape colorElement: aColorOrABlock
]

{ #category : #accessing }
WSShowEdges >> connectFromElements [
	^ connectFromElements
]

{ #category : #accessing }
WSShowEdges >> connectFromElements: anObject [
	connectFromElements := anObject
]

{ #category : #accessing }
WSShowEdges >> connectToElements [
	^ connectToElements
]

{ #category : #public }
WSShowEdges >> connectToElements: aBlock [
	"aBlock accepts a element and returns a list of elements"
	"aBlock return an element or a list of elements to highlight"
	connectToElements := aBlock
]

{ #category : #actions }
WSShowEdges >> doHideEdges: element [
	(element attributes includesKey: #showEdges)
		ifFalse: [ ^ self ].

	(element attributes at: #showEdges) do: [ :el | el view ifNotNil: [ el remove ] ].

	element attributes removeKey: #showEdges
]

{ #category : #actions }
WSShowEdges >> doShowEdges: element [
	| toElements toEdges fromElements fromEdges allEdges |
	self removeAllAddedEdges.

	toElements := (connectToElements rtValue: element) copyWithout: nil.
	toEdges := (toShape rtValue: element)
		edgesFrom: (receiver rtValue: element)
		toAll: toElements.

	fromElements := (connectFromElements rtValue: element)
		copyWithout: nil.
	fromEdges := (fromShape rtValue: element)
		edgesFrom: (receiver rtValue: element) toAll: fromElements.

	allEdges := fromEdges , toEdges.
	element view addAll: allEdges.

	element attributes at: #showEdges put: allEdges.
	self class lastHighlightedElements: allEdges
]

{ #category : #accessing }
WSShowEdges >> fromShape [
	^ fromShape
]

{ #category : #accessing }
WSShowEdges >> fromShape: anObject [
	fromShape := anObject
]

{ #category : #configuration }
WSShowEdges >> highlightedColor [
	^ self class highlightedColor
]

{ #category : #initialize }
WSShowEdges >> initialize [
	super initialize.
	connectToElements := [ :el | Array with: el ].
	receiver := #yourself.
	self toShape: RTArrowedLine new.
	self fromShape: RTArrowedLine new inverted
]

{ #category : #hooks }
WSShowEdges >> initializeElement: element [
	element
		when: TRMouseEnter
		do: [ :e | 
			self doShowEdges: element.
			e signalUpdate ].
	element
		when: TRMouseLeave
		do: [ :e | 
			self doHideEdges: element.
			e signalUpdate ]
]

{ #category : #accessing }
WSShowEdges >> receiver [
	^ receiver
]

{ #category : #accessing }
WSShowEdges >> receiver: anElementOrBlock [
	receiver := anElementOrBlock
]

{ #category : #actions }
WSShowEdges >> recordElement: anElement [
	anElement attributes at: #originalColor put: (anElement trachelShape color)

]

{ #category : #actions }
WSShowEdges >> removeAllAddedEdges [
	self class lastHighlightedElements ifNil: [ ^ self ].
	(self class lastHighlightedElements select: [ :edge | edge view notNil ]) 
		do: #remove.
	self class lastHighlightedElements: nil
]

{ #category : #accessing }
WSShowEdges >> toShape [
	"Return the line shape"
	^ toShape
]

{ #category : #accessing }
WSShowEdges >> toShape: aLineShapeOrABlock [
	"Set the line shape used to draw the edges"
	"The argument is rtValued against the element to display"
	toShape := aLineShapeOrABlock
]
