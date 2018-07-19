Class {
	#name : #UnrestPluggableEndpoint,
	#superclass : #UnrestEndpoint,
	#instVars : [
		'path',
		'data'
	],
	#category : #Unrest
}

{ #category : #accessing }
UnrestPluggableEndpoint >> data [
	^ data
]

{ #category : #data }
UnrestPluggableEndpoint >> dataAt: aPropertyName put: aValue [
	data at: aPropertyName put: aValue
]

{ #category : #data }
UnrestPluggableEndpoint >> dataRemoveAll [
	data removeAll
]

{ #category : #data }
UnrestPluggableEndpoint >> dataRemoveAt: aPropertyName [
	data remove: aPropertyName ifAbsent: [  ]
]

{ #category : #accessing }
UnrestPluggableEndpoint >> endpointPath [
	^ path
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initialize [
	super initialize.
	self initializeData 
]

{ #category : #initialization }
UnrestPluggableEndpoint >> initializeData [
	data := Dictionary new
]

{ #category : #accessing }
UnrestPluggableEndpoint >> path [
	^ path
]

{ #category : #accessing }
UnrestPluggableEndpoint >> path: anObject [
	path := anObject
]

{ #category : #data }
UnrestPluggableEndpoint >> resetData [
	self initializeData
]
