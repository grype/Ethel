Class {
	#name : #WSMapItem,
	#superclass : #Object,
	#instVars : [
		'item'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
WSMapItem class >> handles: anObj [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
WSMapItem class >> with: anObj map: aMap [
	^ (self allSubclasses select: [ :each | each subclasses isEmpty ])
		detect: [ :cls | cls handles: anObj ]
		ifFound: [ :cls | cls basicNew initializeWith: anObj map: aMap ]
		ifNone: [ Error
				signal: 'No WSMapItem subclass handles object of type ' , anObj class asString ]
]

{ #category : #accessing }
WSMapItem >> children [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
WSMapItem >> description [ 
	^ self subclassResponsibility 
]

{ #category : #initialization }
WSMapItem >> initializeWith: anObj map: anObject [
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
