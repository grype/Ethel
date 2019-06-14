Extension { #name : #TWSEndpoint }

{ #category : #'*Ethel-Tools' }
TWSEndpoint >> gtPathReferences [
	^ ((Array
		with: self class pathReferences
		with:
			(self class wsEndpointReferences
				collect: [ :each | each key -> each value anyOne endpointPath ]))
		collect: [ :each | 
			each
				sorted: [ :a :b | a value wsGtPrintString < b value wsGtPrintString ] ])
		flattened
]

{ #category : #'*Ethel-Tools' }
TWSEndpoint >> gtPathReferencesIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite table
		title: [ 'Paths' translated ];
		display: [ self gtPathReferences ];
		when: [ self class pathReferences isEmptyOrNil not ];
		column: 'Implementor' evaluated: [ :each | each key selector ];
		column: 'Path' evaluated: [ :each | each value wsGtPrintString ]
]

{ #category : #'*Ethel-Tools' }
TWSEndpoint classSide >> gtUMLIn: aComposite [
	<gtInspectorPresentationOrder: 13>
	^ aComposite roassal2
		title: [ 'UML' translated ];
		initializeView: [ WSUMLBuilder new ];
		painting: [ :view | 
			| uml |
			uml := WSUml onEndpointClass: self.
			uml selectedObject: self.
			uml buildOn: view ]
]

{ #category : #'*Ethel-Tools' }
TWSEndpoint >> gtUMLIn: aComposite [
	<gtInspectorPresentationOrder: 13>
	^ self class gtUMLIn: aComposite
]
