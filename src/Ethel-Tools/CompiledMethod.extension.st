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
