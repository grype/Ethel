Class {
	#name : #WSMapClientItem,
	#superclass : #WSMapItem,
	#category : #'Ethel-Tools-Map'
}

{ #category : #'instance creation' }
WSMapClientItem class >> handles: anObj [
	^ anObj isKindOf: WSClient
]

{ #category : #accessing }
WSMapClientItem >> description [ 
	^ item baseUrl
]

{ #category : #testing }
WSMapClientItem >> shapeBorderColor [
	^ Color colorFrom: '#4682B4'
]

{ #category : #testing }
WSMapClientItem >> shapeColor [
	^ Color transparent
]
