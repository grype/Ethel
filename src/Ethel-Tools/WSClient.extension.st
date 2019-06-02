Extension { #name : #WSClient }

{ #category : #'*Ethel-Tools' }
WSClient >> buildMapOn: aBuilder [
	| map |

	map := WSMap onClient: self.
	map buildMapOn: aBuilder
]

{ #category : #'*Ethel-Tools' }
WSClient >> buildUMLOn: aBuilder [
	| uml |
	uml := WSUml onClient: self.
	uml buildOn: aBuilder
]

{ #category : #'*Ethel-Tools' }
WSClient >> gtMapIn: aComposite [
	<gtInspectorPresentationOrder: 11>
	^ aComposite roassal2
		title: ['Map' translated];
		initializeView: [ WSMapBuilder new ];
		painting: [ :view | self buildMapOn: view ]
]

{ #category : #'*Ethel-Tools' }
WSClient >> gtUMLIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite roassal2
		title: ['UML' translated];
		initializeView: [ RTUMLClassBuilder new ];
		painting: [ :view | self buildUMLOn: view ]
]
