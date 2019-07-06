Class {
	#name : #WSMapMethodItem,
	#superclass : #WSMapItem,
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

{ #category : #testing }
WSMapMethodItem >> shapeBorderColor [
	^ Color colorFrom: '#4682B4'
]

{ #category : #testing }
WSMapMethodItem >> shapeColor [
	^ (item collect: #methodClass)
		detect: [ :each | each traitComposition includesTrait: TWSEnumeration ]
		ifFound: [ (Color colorFrom: '#4682B4') alpha: 0.3 ]
		ifNone: [ Color transparent ]
]
