Class {
	#name : #WSJsonContentBuilder,
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
WSJsonContentBuilder class >> fromPragma: aPragma [
	^ aPragma = 'json'
		  ifTrue: [ self new ]
		  ifFalse: [ nil ]
]

{ #category : #'building - transport' }
WSJsonContentBuilder >> accept: aTransportVisitor [
	aTransportVisitor visitJsonContentBuilder: self
]

{ #category : #initialization }
WSJsonContentBuilder >> initialize [
	super initialize.
	reader := [ :aJsonString | NeoJSONReader fromString: aJsonString ].
	writer := [ :obj | ZnEntity json: (NeoJSONWriter toString: obj) ]
]

{ #category : #accessing }
WSJsonContentBuilder >> reader [

	^ reader
]

{ #category : #accessing }
WSJsonContentBuilder >> reader: anObject [

	reader := anObject
]

{ #category : #accessing }
WSJsonContentBuilder >> writer [

	^ writer
]

{ #category : #accessing }
WSJsonContentBuilder >> writer: anObject [

	writer := anObject
]
