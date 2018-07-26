Class {
	#name : #UnrestInteractiveTreeBuilder,
	#superclass : #RTInteractiveTreeBuilder,
	#instVars : [
		'clickHandler'
	],
	#category : #Unrest
}

{ #category : #accessing }
UnrestInteractiveTreeBuilder >> clickHandler [
	^ clickHandler
]

{ #category : #accessing }
UnrestInteractiveTreeBuilder >> clickHandler: anObject [
	clickHandler := anObject
]

{ #category : #interactions }
UnrestInteractiveTreeBuilder >> clickOnElement: e [
	(self isElementOpened: e)
		ifTrue: [ self closeElement: e ]
		ifFalse: [ self openElement: e ].
	clickHandler ifNotNil: [ :aBlock | aBlock cull: e ]
]
