Class {
	#name : #WSEndpointExecutorMethodQuery,
	#superclass : #ClyMethodQuery,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #testing }
WSEndpointExecutorMethodQuery >> description [
	^'endpoint executor'
]

{ #category : #testing }
WSEndpointExecutorMethodQuery >> selectsMethod: aMethod [
	^ aMethod isWSEndpointExecutionMethod 
]
