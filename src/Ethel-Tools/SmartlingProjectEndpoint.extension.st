Extension { #name : #SmartlingProjectEndpoint }

{ #category : #'*Ethel-Tools' }
SmartlingProjectEndpoint >> gtPathReferencesIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite table
		title: [ 'Paths' translated ];
		display: [ self gtPathReferences ];
		when: [ self gtPathReferences isEmptyOrNil not ];
		column: 'Path' evaluated: [ :each | each value wsGtPrintString ];
		column: 'Implementor' evaluated: [ :each | each key selector ]
]
