Class {
	#name : #WSEndpointEnvironmentPlugin,
	#superclass : #ClySystemEnvironmentPlugin,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #'groups collecting' }
WSEndpointEnvironmentPlugin >> collectMethodGroupProviders [
	^{ WSEndpointReferenceMethodGroupProvider new. WSEndpointExecutorMethodGroupProvider new}
]

{ #category : #'item decoration' }
WSEndpointEnvironmentPlugin >> decorateBrowserItem: anItem ofMethod: aMethod [
	aMethod isWSEndpointExecutionMethod
		ifTrue: [ anItem markWith: WSEndpointExecutorTag ].
	aMethod isWSEndpointReferencingMethod
		ifTrue: [ anItem markWith: WSEndpointReferenceTag ]
]
