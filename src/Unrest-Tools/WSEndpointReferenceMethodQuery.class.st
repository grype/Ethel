Class {
	#name : #WSEndpointReferenceMethodQuery,
	#superclass : #ClyMethodQuery,
	#category : #'Unrest-Tools-Browser-Plugins'
}

{ #category : #testing }
WSEndpointReferenceMethodQuery >> description [
	^'endpoint references'
]

{ #category : #testing }
WSEndpointReferenceMethodQuery >> selectsMethod: aMethod [
	^ aMethod isWSEndpointReferencingMethod
]
