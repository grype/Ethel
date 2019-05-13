Class {
	#name : #WSMapMethodItem,
	#superclass : #WSMapItem,
	#instVars : [
		'colorMap'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
WSMapMethodItem class >> handles: anObj [
	^ anObj isKindOf: CompiledMethod
]

{ #category : #accessing }
WSMapMethodItem >> children [
	^ Set new
]

{ #category : #accessing }
WSMapMethodItem >> description [ 
	^ '#' , item selector
]

{ #category : #initialization }
WSMapMethodItem >> initializeWith: anObj map: aMap [
	| colors httpMethods |

	super initializeWith: anObj map: self.
	httpMethods := aMap client class supportedHttpMethods.
	colors := RTColorPalette qualitative
		colors: httpMethods size
		scheme: 'Dark2'.
	colorMap := (httpMethods
		withIndexCollect: [ :each :i | each asLowercase -> (colors at: i) ])
		asDictionary
]

{ #category : #testing }
WSMapMethodItem >> shapeBorderColor [
	^ Color transparent
]

{ #category : #testing }
WSMapMethodItem >> shapeColor [
	^ colorMap at: item wsEndpointHttpMethod asLowercase
]
