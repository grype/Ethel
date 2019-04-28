Class {
	#name : #WSEndpointReferenceMethodQuery,
	#superclass : #ClyMethodQuery,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #testing }
WSEndpointReferenceMethodQuery >> description [
	^'endpoint references'
]

{ #category : #testing }
WSEndpointReferenceMethodQuery >> selectsMethod: aMethod [
	^ aMethod isWSEndpointReferencingMethod
]
