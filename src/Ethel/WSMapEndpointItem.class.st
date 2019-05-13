Class {
	#name : #WSMapEndpointItem,
	#superclass : #WSMapItem,
	#instVars : [
		'children'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
WSMapEndpointItem class >> handles: anObj [
	^ anObj isWSEndpoint
]

{ #category : #accessing }
WSMapEndpointItem >> children [
	^ children
]

{ #category : #accessing }
WSMapEndpointItem >> description [ 
	^ item endpointPath segments last
]

{ #category : #initialization }
WSMapEndpointItem >> initializeWith: anObj map: aMap [
	| ourPath |

	super initializeWith: anObj map: aMap.
	ourPath := anObj endpointPath.
	children := (aMap associations
		select: [ :each | 
			(each key segments size = (ourPath segments size + 1))
				and: [ each key segments beginsWith: ourPath segments ] ]) flatCollect: [ :each | each value asOrderedCollection ]
]

{ #category : #testing }
WSMapEndpointItem >> shapeBorderColor [
	^ (item isKindOf: WSPluggableEndpoint)
		ifTrue: [ Color gray ]
		ifFalse: [ Color colorFrom: '#4682B4' ]
]

{ #category : #testing }
WSMapEndpointItem >> shapeColor [
	^ ((item isKindOf: WSPluggableEndpoint) not
		and: [ item class traitComposition includesTrait: TWSEnumeration class ])
		ifTrue: [ (Color colorFrom: '#4682B4') alpha: 0.2 ]
		ifFalse: [ Color transparent ]
]
