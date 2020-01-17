Extension { #name : #WSClient }

{ #category : #'*Ethel-Tools' }
WSClient >> buildMapOn: aBuilder [
	| map |

	map := WSMap onClient: self.
	map buildMapOn: aBuilder
]

{ #category : #'*Ethel-Tools' }
WSClient class >> buildUMLOn: aBuilder [
	| uml |
	uml := WSUml onClientClass: self.
	uml buildOn: aBuilder
]

{ #category : #'*Ethel-Tools' }
WSClient >> curlForExecuting: anEndpoint [
	^ self curlForExecuting: anEndpoint with: nil
]

{ #category : #'*Ethel-Tools' }
WSClient >> curlForExecuting: anEndpoint with: aBlock [
	| http |
	http := self createHttpClient.
	"Unlike the execute method, we execute the block before going through regular routine of setting up the transport. This is because when calling this method, we're bypassing the regular method execution, which leaves us without context from which we can determine the executing method's pragmas for HTTP method, path etc. The supplied block allows us to do just that - to configure the transport appropriately as if it's being executed by the actual executing method"
	aBlock ifNotNil: [ :block | block cull: http ].
	anEndpoint prepareForExecutingOn: http.
	anEndpoint configureOn: http.
	^ http curl
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
WSClient class >> gtUMLIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite roassal2
		title: ['UML' translated];
		initializeView: [ WSUMLBuilder new ];
		painting: [ :view | self buildUMLOn: view ]
]

{ #category : #'*Ethel-Tools' }
WSClient >> gtUMLIn: aComposite [
	<gtInspectorPresentationOrder: 12>
	^ aComposite roassal2
		title: ['UML' translated];
		initializeView: [ WSUMLBuilder new ];
		painting: [ :view | self class buildUMLOn: view ]
]

{ #category : #'*Ethel-Tools' }
WSClient class >> wsUmlSortOrder [
	^ 1
]
