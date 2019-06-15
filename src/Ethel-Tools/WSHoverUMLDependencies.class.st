Class {
	#name : #WSHoverUMLDependencies,
	#superclass : #RTInteraction,
	#instVars : [
		'edgeBuilder'
	],
	#classVars : [
		'AttributeName'
	],
	#category : #'Ethel-Tools-UML'
}

{ #category : #'class initialization' }
WSHoverUMLDependencies class >> initialize [ 
	AttributeName := 'ShowsUMLDependencies'
]

{ #category : #hooks }
WSHoverUMLDependencies >> attributeName [
	^ AttributeName
]

{ #category : #hooks }
WSHoverUMLDependencies >> createEdgesFrom: element [
	| cls fromElements references toElements |
	cls := element model.
	references := cls wsEndpointReferences.
	toElements := element view elements
		select: [ :each | each isClass and: [ references includes: each ] ].
	fromElements := element view elements
		select:
			[ :each | each model isClass and: [ each model referencedClasses includes: cls ] ].
	edgeBuilder view: element view.
	edgeBuilder objects: (toElements , fromElements collect: #model).
	edgeBuilder connectFrom: [ :i | fromElements includes: i ].
	edgeBuilder connectTo: [ :i | toElements includes: i ]
]

{ #category : #hooks }
WSHoverUMLDependencies >> hideDependenciesFor: element [

]

{ #category : #initialization }
WSHoverUMLDependencies >> initialize [
	edgeBuilder := RTEdgeBuilder new
]

{ #category : #hooks }
WSHoverUMLDependencies >> initializeElement: element [
	element
		when: TRMouseEnter
		do: [ :anEvent | self showDependenciesFor: element ].

	element
		when: TRMouseLeave
		do: [ :anEvent | self hideDependenciesFor: element ]
]

{ #category : #hooks }
WSHoverUMLDependencies >> showDependenciesFor: element [
	(element hasAttribute: self attributeName)
		ifTrue: [ ^ self ].
	element view elements do: [ :each | self hideDependenciesFor: each ].
	element attributeAt: self attributeName put: edgeBuilder.
	self createEdgesFrom: element
]
