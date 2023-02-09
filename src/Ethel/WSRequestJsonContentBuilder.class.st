Class {
	#name : #WSRequestJsonContentBuilder,
	#superclass : #Object,
	#traits : 'TWSTransportBuilder',
	#classTraits : 'TWSTransportBuilder classTrait',
	#instVars : [
		'reader',
		'writer'
	],
	#category : #'Ethel-Builders'
}

{ #category : #'instance creation' }
WSRequestJsonContentBuilder class >> fromPragma: aPragma [
	^ aPragma = 'json'
		  ifTrue: [ self new ]
		  ifFalse: [ nil ]
]

{ #category : #'building - transport' }
WSRequestJsonContentBuilder >> accept: aTransportVisitor [
	aTransportVisitor visitJsonContentBuilder: self
]

{ #category : #initialization }
WSRequestJsonContentBuilder >> initialize [
	super initialize.
	reader := [ :aJsonString | NeoJSONReader fromString: aJsonString ].
	writer := [ :obj | ZnEntity json: (NeoJSONWriter toString: obj) ]
]

{ #category : #accessing }
WSRequestJsonContentBuilder >> reader [

	^ reader
]

{ #category : #accessing }
WSRequestJsonContentBuilder >> reader: anObject [

	reader := anObject
]

{ #category : #accessing }
WSRequestJsonContentBuilder >> writer [

	^ writer
]

{ #category : #accessing }
WSRequestJsonContentBuilder >> writer: anObject [

	writer := anObject
]
