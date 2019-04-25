Class {
	#name : #WSEndpointExecutorMethodGroupProvider,
	#superclass : #ClySingleMethodGroupProvider,
	#category : #'Unrest-Tools-Browser-Plugins'
}

{ #category : #'building groups' }
WSEndpointExecutorMethodGroupProvider >> createMethodGroupFor: aMethodQuery from: aClassScope [
	^ WSEndpointExecutorMethodGroup
		named: 'endpoint methods'
		priority: -9
		on: aMethodQuery
]

{ #category : #'building groups' }
WSEndpointExecutorMethodGroupProvider >> createMethodQueryFrom: aClassScope [
	^WSEndpointExecutorMethodQuery from: aClassScope
]
