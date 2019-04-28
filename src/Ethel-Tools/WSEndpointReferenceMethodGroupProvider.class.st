Class {
	#name : #WSEndpointReferenceMethodGroupProvider,
	#superclass : #ClySingleMethodGroupProvider,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #'building groups' }
WSEndpointReferenceMethodGroupProvider >> createMethodGroupFor: aMethodQuery from: aClassScope [
	^ WSEndpointReferenceMethodGroup
		named: 'endpoint references'
		priority: -9
		on: aMethodQuery
]

{ #category : #'building groups' }
WSEndpointReferenceMethodGroupProvider >> createMethodQueryFrom: aClassScope [
	^WSEndpointReferenceMethodQuery from: aClassScope
]
