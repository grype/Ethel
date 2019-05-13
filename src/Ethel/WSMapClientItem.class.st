Class {
	#name : #WSMapClientItem,
	#superclass : #WSMapItem,
	#instVars : [
		'children'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
WSMapClientItem class >> handles: anObj [
	^ anObj isKindOf: WSClient
]

{ #category : #accessing }
WSMapClientItem >> children [
	^ children
]

{ #category : #accessing }
WSMapClientItem >> description [ 
	^ item baseUrl
]

{ #category : #initialization }
WSMapClientItem >> initializeWith: anObj map: aMap [
	super initializeWith: anObj map: aMap.
	children := (aMap associations
		select: [ :each | each key segments size = 1 ])
		flatCollect: [ :each | each value asOrderedCollection ]
]

{ #category : #testing }
WSMapClientItem >> shapeBorderColor [
	^ Color colorFrom: '#4682B4'
]

{ #category : #testing }
WSMapClientItem >> shapeColor [
	^ Color transparent
]
