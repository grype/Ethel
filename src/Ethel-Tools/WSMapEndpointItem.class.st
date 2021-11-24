Class {
	#name : #WSMapEndpointItem,
	#superclass : #WSMapItem,
	#category : #'Ethel-Tools-Map'
}

{ #category : #'instance creation' }
WSMapEndpointItem class >> handles: anObj [
	^ anObj isWSEndpoint
]

{ #category : #accessing }
WSMapEndpointItem >> description [ 
	^ item class pathPrefix segments last
]

{ #category : #testing }
WSMapEndpointItem >> shapeBorderColor [
	^ (item isKindOf: WSPluggableEndpoint)
		ifTrue: [ Color gray ]
		ifFalse: [ (item class wsEndpointExecutingMethods
				select: [ :each | each wsEndpointPath = item class pathPrefix ])
				ifEmpty: [ Smalltalk ui theme warningTextColor alpha: 0.5 ]
				ifNotEmpty: [ Color colorFrom: '#4682B4' ] ]
]

{ #category : #testing }
WSMapEndpointItem >> shapeColor [
	^ ((item isKindOf: WSPluggableEndpoint) not
		and: [ item class traitComposition includesTrait: TWSEnumeration class ])
		ifTrue: [ (Color colorFrom: '#4682B4') alpha: 0.2 ]
		ifFalse: [ Color transparent ]
]
