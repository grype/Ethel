Class {
	#name : #WSContextBuilder,
	#superclass : #Object,
	#traits : 'TWSTransportBuilder',
	#classTraits : 'TWSTransportBuilder classTrait',
	#instVars : [
		'block'
	],
	#category : #'Ethel-Builders'
}

{ #category : #'instance creation' }
WSContextBuilder class >> fromPragma: aPragma [
	^ nil
]

{ #category : #'instance creation' }
WSContextBuilder class >> with: aBlock [
	^ self new
		  block: aBlock;
		  yourself
]

{ #category : #'building - transport' }
WSContextBuilder >> accept: aTransportVisitor [
	aTransportVisitor visitContextBuilder: self
]

{ #category : #accessing }
WSContextBuilder >> block [

	^ block
]

{ #category : #accessing }
WSContextBuilder >> block: anObject [

	block := anObject
]
