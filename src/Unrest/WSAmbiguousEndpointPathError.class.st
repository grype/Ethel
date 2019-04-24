Class {
	#name : #WSAmbiguousEndpointPathError,
	#superclass : #Error,
	#instVars : [
		'path'
	],
	#category : #'Unrest-Core'
}

{ #category : #signaling }
WSAmbiguousEndpointPathError >> signal: aPath [
	path := aPath.
	super signal: ('There is more than one class implementing endpoint for {1}. Check using WSClient>>#implementorsOfPath:' format: { aPath }).
]
