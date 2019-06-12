Class {
	#name : #WSUMLBuilder,
	#superclass : #RTUMLClassBuilder,
	#category : #'Ethel-Tools'
}

{ #category : #edges }
WSUMLBuilder >> buildEdges [
	super buildEdges.
	"self buildEdgesForDependents: classes"
]

{ #category : #edges }
WSUMLBuilder >> buildEdgesForDependents: dependents [
	| eb |
	eb := RTEdgeBuilder new.
	eb view: view.
	eb notUseInLayout.
	eb objects: dependents.
	eb shape doubleArrowedBezier
		headStart: RTFilledNarrowArrow asTail;
		headEnd: RTNoDecorationShape asHead.
	eb shape color: [ (Color colorFrom: '#4682B4') alpha: 0.5 ].
	eb
		addAction: [ :edge | 
			edge
				@ (RTHighlightable new highlightedColor: (Color colorFrom: '#4682B4')) ].
	dependents
		do: [ :cls | 
			cls referencedClasses do: [ :ref | eb connectFrom: ref to: cls ].
			cls traitComposition traits
				do: [ :trt | eb connectFrom: trt to: cls ] ]
]
