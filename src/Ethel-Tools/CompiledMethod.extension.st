Extension { #name : #CompiledMethod }

{ #category : #'*Ethel-Tools' }
CompiledMethod >> gtUMLIn: aComposite [
	<gtInspectorPresentationOrder: 13>
	^ aComposite roassal2
		title: [ 'UML' translated ];
		initializeView: [ WSUMLBuilder new ];
		painting: [ :view | 
			| uml |
			uml := WSUml onEndpointClass: self methodClass.
			uml selectedObject: self methodClass.
			uml buildOn: view ]
]

{ #category : #'*Ethel-Tools' }
CompiledMethod >> isWSEndpointReferencingMethod [

	^ self referencedClasses
		  detect: #isWSEndpoint
		  ifFound: [ true ]
		  ifNone: [ false ]
]

{ #category : #'*Ethel-Tools' }
CompiledMethod >> wsEndpointExecutionParams [

	^ self ffiArgumentNames
]

{ #category : #'*Ethel-Tools' }
CompiledMethod >> wsEndpointPath [

	^ self wsEndpointAccessor ifNotNil: [ :accessor | accessor path ]
]
