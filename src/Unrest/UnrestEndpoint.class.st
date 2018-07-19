Class {
	#name : #UnrestEndpoint,
	#superclass : #Object,
	#instVars : [
		'unrest'
	],
	#category : #Unrest
}

{ #category : #'instance creation' }
UnrestEndpoint class >> on: unrestClient [
	^ self basicNew initializeOn: unrestClient
]

{ #category : #endpoints }
UnrestEndpoint >> / aString [
	"Creates a new generic endpoint by appending a new path."

	^ (self > UnrestPluggableEndpoint)
		path: self endpointPath / aString;
		yourself
]

{ #category : #endpoints }
UnrestEndpoint >> > endPointClass [
	"Creates a new endpoint of specified class."
	^ endPointClass on: unrest
]

{ #category : #accessing }
UnrestEndpoint >> endpointPath [
	^ self subclassResponsibility
]

{ #category : #initialization }
UnrestEndpoint >> initializeOn: unrestClient [
	self initialize.
	unrest := unrestClient
]
