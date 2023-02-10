Class {
	#name : #WSContentBuilder,
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
WSContentBuilder class >> fromPragma: aPragma [
	| reader writer |

	reader := aPragma selector = #readContent:
		          ifTrue: [ aPragma arguments first asSymbol ]
		          ifFalse: [ nil ].
	writer := aPragma selector = #writeContent:
		          ifTrue: [ aPragma arguments first asSymbol ]
		          ifFalse: [ nil ].
	(reader isNil and: [ writer isNil ]) ifTrue: [ ^ nil ].

	^ self new
		  reader: reader;
		  writer: writer;
		  yourself
]

{ #category : #visiting }
WSContentBuilder >> accept: aTransportVisitor [
	aTransportVisitor visitContentBuilder: self
]

{ #category : #accessing }
WSContentBuilder >> reader [

	^ reader
]

{ #category : #accessing }
WSContentBuilder >> reader: anObject [

	reader := anObject
]

{ #category : #accessing }
WSContentBuilder >> writer [

	^ writer
]

{ #category : #accessing }
WSContentBuilder >> writer: anObject [

	writer := anObject
]
