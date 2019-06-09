"
I am raised whenever there's an ambiguity in resolving a conrete endpoint class for a specific path. This would happen when multiple classes using ==TWSEndpoint== reports the same Path via #endpointPath.

Instance Variables
	path:		<Path> Conflicting endpoint path
"
Class {
	#name : #WSAmbiguousEndpointPathError,
	#superclass : #WSError,
	#instVars : [
		'path'
	],
	#category : #'Ethel-Core'
}

{ #category : #private }
WSAmbiguousEndpointPathError >> isResumable [
	^ false
]

{ #category : #signaling }
WSAmbiguousEndpointPathError >> signal: aPath [
	path := aPath.
	super signal: ('There is more than one class implementing endpoint for {1}. Check using WSClient>>#implementorsOfPath:' format: { aPath }).
]
