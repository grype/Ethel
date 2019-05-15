Class {
	#name : #WSMapItem,
	#superclass : #Object,
	#instVars : [
		'item'
	],
	#category : #'Ethel-Tools-Map'
}

{ #category : #'instance creation' }
WSMapItem class >> handles: anObj [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
WSMapItem class >> with: anObj forMap: aMap [
	^ (self allSubclasses select: [ :each | each subclasses isEmpty ])
		detect: [ :cls | cls handles: anObj ]
		ifFound: [ :cls | cls basicNew initializeWith: anObj forMap: aMap ]
		ifNone: [ Error
				signal: 'No WSMapItem subclass handles object of type ' , anObj class asString ]
]

{ #category : #accessing }
WSMapItem >> description [ 
	^ self subclassResponsibility 
]

{ #category : #initialization }
WSMapItem >> initializeWith: anObj forMap: aMap [
	self initialize.
	item := anObj
]

{ #category : #testing }
WSMapItem >> shapeBorderColor [
	^ self subclassResponsibility 
]

{ #category : #testing }
WSMapItem >> shapeColor [
	^ self subclassResponsibility 
]
