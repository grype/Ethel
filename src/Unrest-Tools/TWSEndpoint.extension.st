Extension { #name : #TWSEndpoint }

{ #category : #'*Unrest-Tools' }
TWSEndpoint >> gtPathReferencesIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite table
		title: [ 'Paths' translated ];
		display: [ self class pathReferences ];
		when: [ self class pathReferences isEmptyOrNil not ];
		column: 'Path' evaluated: [ :each | each value pathString ];
		column: 'Implementor' evaluated: [ :each | each key selector ]
]
