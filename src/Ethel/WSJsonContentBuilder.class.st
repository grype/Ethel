Class {
	#name : #WSJsonContentBuilder,
	#superclass : #WSContentBuilder,
	#classTraits : 'TWSTransportBuilder classTrait',
	#category : #'Ethel-Builders'
}

{ #category : #'instance creation' }
WSJsonContentBuilder class >> fromPragma: aPragma [
	^ aPragma = 'json'
		  ifTrue: [ self new ]
		  ifFalse: [ nil ]
]

{ #category : #initialization }
WSJsonContentBuilder >> initialize [
	super initialize.
	reader := [ :aJsonString | NeoJSONReader fromString: aJsonString ].
	writer := [ :obj | ZnEntity json: (NeoJSONWriter toString: obj) ]
]
