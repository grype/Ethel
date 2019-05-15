Class {
	#name : #WSMapMethodItem,
	#superclass : #WSMapItem,
	#instVars : [
		'endpoint'
	],
	#category : #'Ethel-Tools-Map'
}

{ #category : #'instance creation' }
WSMapMethodItem class >> handles: anObj [
	^ anObj isCollection
		and: [ anObj anySatisfy: [ :each | each isWSEndpointExecutionMethod ] ]
]

{ #category : #accessing }
WSMapMethodItem >> description [ 
	^ item anyOne wsEndpointPath segments last
]

{ #category : #initialization }
WSMapMethodItem >> initializeWith: anObj forMap: aMap [
	super initializeWith: anObj forMap: aMap.
	endpoint := aMap client endpointForPath: anObj anyOne wsEndpointPath.
	(endpoint isKindOf: WSPluggableEndpoint)
		ifTrue: [ endpoint := nil ]
]

{ #category : #testing }
WSMapMethodItem >> shapeBorderColor [
	^ Color colorFrom: '#4682B4'
]

{ #category : #testing }
WSMapMethodItem >> shapeColor [
	| isEnumeratedEndpoing |

	isEnumeratedEndpoing := endpoint
		ifNil: [ false ]
		ifNotNil: [ :ep | ep class traitComposition includesTrait: TWSEnumeration ].
	^ isEnumeratedEndpoing
		ifTrue: [ (Color colorFrom: '#4682B4') alpha: 0.3 ]
		ifFalse: [ Color transparent ]
]
