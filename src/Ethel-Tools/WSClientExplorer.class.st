"
I provide basic UI for configuring and executing endpoints on an instance of WSClient.

Example:

(WSClientExplorer on: myClient) openWithSpec.
"
Class {
	#name : #WSClientExplorer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'apiClient',
		'pathLabel',
		'pathSelector',
		'methodLabel',
		'methodSelector',
		'goButton',
		'params'
	],
	#category : #'Ethel-Tools-Widgets'
}

{ #category : #specs }
WSClientExplorer class >> defaultSpec [
	| rows spec labelWidth rowCount |
	rows := #(#(#pathLabel #pathSelector) #(#params) #(#methodSelector #goButton)).
	labelWidth := 100.
	spec := SpecLayout composed.
	spec
		newRow: [ :row | 
			row
				add: #pathLabel width: labelWidth;
				add: #pathSelector ]
		origin: 0 @ 0
		corner: 1 @ 0
		offsetOrigin: 0 @ 0
		offsetCorner: 0 @ self toolbarHeight.
	spec
		newRow: [ :row | row add: #params ]
		origin: 0 @ 0
		corner: 1 @ 1
		offsetOrigin: 0 @ self toolbarHeight
		offsetCorner: 0 @ (1 - self toolbarHeight).
	spec
		newRow: [ :row | 
			row
				add: #methodSelector width: labelWidth;
				add: #goButton ]
		origin: 0 @ 1
		corner: 1 @ 1
		offsetOrigin: 0 @ (1 - self toolbarHeight)
		offsetCorner: 0 @ 0.
	^ spec
]

{ #category : #'instance creation' }
WSClientExplorer class >> on: aClient [
	^ self basicNew
		apiClient: aClient;
		initialize
]

{ #category : #accessing }
WSClientExplorer >> apiClient [
	^ apiClient
]

{ #category : #accessing }
WSClientExplorer >> apiClient: anObject [
	apiClient := anObject
]

{ #category : #initialization }
WSClientExplorer >> executingMethods [
	| methods |
	methods := apiClient class derivedWSEndpoints
		flatCollect: [ :each | each wsEndpointExecutingMethods ].
	^ (methods
		collect: [ :each | each wsEndpointPath pathString -> each methodClass ])
		sorted: [ :a :b | a key < b key ]
]

{ #category : #initialization }
WSClientExplorer >> go [
	| endpoint |
	endpoint := self params endpointClass on: apiClient.
	self params configureOn: endpoint.
	(endpoint
		execute: [ :http | 
			http
				url:
					(self pathSelector selectedItem key
						format: self params paramsWithValues).
			http method: self methodSelector selectedItem asString asUppercase ])
		inspect
]

{ #category : #accessing }
WSClientExplorer >> goButton [
	^ goButton
]

{ #category : #accessing }
WSClientExplorer >> goButton: anObject [
	goButton := anObject
]

{ #category : #initialization }
WSClientExplorer >> httpMethods [
	| methods |
	methods := CdClient derivedWSEndpoints
		flatCollect: [ :each | each wsEndpointExecutingMethods ].
	^ (methods collect: [ :each | each wsEndpointHttpMethod ]) asSet
		sorted: [ :a :b | a < b ]
]

{ #category : #initialization }
WSClientExplorer >> initializeWidgets [
	pathLabel := self newLabel
		label: 'Path';
		yourself.
	pathSelector := self newDropList
		items: self executingMethods;
		displayBlock: [ :each | each key ];
		whenSelectedItemChanged: [ :item | 
			self loadParametersForClass: item value path: item key.
			self needRebuild: false.
			self buildWithSpecLayout: self class defaultSpec ];
		yourself.
	methodLabel := self newLabel
		label: 'Method';
		yourself.
	methodSelector := self newDropList
		items: self httpMethods;
		displayBlock: [ :each | each asString asUppercase ];
		yourself.
	goButton := self newButton
		label: 'Go';
		action: [ self go ].
	self executingMethods first
		in:
			[ :assoc | self loadParametersForClass: assoc value path: assoc key ].
	self setupFocusOrder
]

{ #category : #initialization }
WSClientExplorer >> loadParametersForClass: aClass path: aPathString [
	params := self paramsWidgetForClass: aClass path: aPathString
]

{ #category : #accessing }
WSClientExplorer >> methodLabel [
	^ methodLabel
]

{ #category : #accessing }
WSClientExplorer >> methodLabel: anObject [
	methodLabel := anObject
]

{ #category : #accessing }
WSClientExplorer >> methodSelector [
	^ methodSelector
]

{ #category : #accessing }
WSClientExplorer >> methodSelector: anObject [
	methodSelector := anObject
]

{ #category : #accessing }
WSClientExplorer >> params [
	^ params
]

{ #category : #accessing }
WSClientExplorer >> params: anObject [
	params := anObject
]

{ #category : #initialization }
WSClientExplorer >> paramsWidgetForClass: aClass path: aPathString [
	^ self
		instantiate:
			(WSEndpointParamsPresenter
				on: aClass
				withParameters: aPathString formatTokens)
]

{ #category : #accessing }
WSClientExplorer >> pathLabel [
	^ pathLabel
]

{ #category : #accessing }
WSClientExplorer >> pathLabel: anObject [
	pathLabel := anObject
]

{ #category : #accessing }
WSClientExplorer >> pathSelector [
	^ pathSelector
]

{ #category : #accessing }
WSClientExplorer >> pathSelector: anObject [
	pathSelector := anObject
]

{ #category : #initialization }
WSClientExplorer >> setupFocusOrder [
	self focusOrder
		removeAll;
		add: pathSelector;
		add: params;
		add: methodSelector;
		add: goButton
]

{ #category : #api }
WSClientExplorer >> title [
	^ apiClient class name , ' Explorer'
]
