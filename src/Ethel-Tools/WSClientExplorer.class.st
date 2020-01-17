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
		'goButton',
		'params',
		'inspectButton',
		'curlButton'
	],
	#category : #'Ethel-Tools-Widgets'
}

{ #category : #specs }
WSClientExplorer class >> defaultSpec [
	| labelWidth spec |
	labelWidth := 100.
	spec := SpecLayout composed.
	spec
		newRow: [ :row | 
			row
				add: #pathLabel width: labelWidth;
				add: #pathSelector;
				add: #inspectButton width: self toolbarHeight ]
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
				add: #curlButton width: self toolbarHeight;
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

{ #category : #accessing }
WSClientExplorer >> curlButton [
	^ curlButton
]

{ #category : #accessing }
WSClientExplorer >> curlButton: anObject [
	curlButton := anObject
]

{ #category : #initialization }
WSClientExplorer >> executingMethods [
	| methods |
	methods := apiClient class derivedWSEndpoints
		flatCollect: [ :each | each wsEndpointExecutingMethods ].
	^ methods asSet sorted: [ :a :b | a wsEndpointPath pathString < b wsEndpointPath pathString ]
]

{ #category : #actions }
WSClientExplorer >> go [
	| endpoint method args |
	endpoint := self params endpointClass on: apiClient.
	self params configureOn: endpoint.
	method := pathSelector selectedItem.
	args := method wsEndpointExecutionParams
		collect: [ :each | self params valueFor: each asSymbol ].
	(endpoint perform: method selector withArguments: args) inspect
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
WSClientExplorer >> initializeWidgets [
	pathLabel := self newLabel
		label: 'Path';
		yourself.
	pathSelector := self newDropList
		items: self executingMethods;
		displayBlock: [ :each | self pathDescriptionForMethod: each ];
		whenSelectedItemChanged: [ :method | 
			self loadParametersForMethod: method.
			self needRebuild: false.
			self buildWithSpecLayout: self class defaultSpec ];
		yourself.
	inspectButton := self newButton
		icon: (self iconNamed: #smallInfo);
		action: [ self inspectClient ].
	goButton := self newButton
		label: 'Go';
		action: [ self go ].
	curlButton := self newButton
		icon: (self iconNamed: #string);
		action: [ self showCurl ].
	self executingMethods first
		in: [ :method | self loadParametersForMethod: method ].
	self setupFocusOrder
]

{ #category : #accessing }
WSClientExplorer >> inspectButton [
	^ inspectButton
]

{ #category : #accessing }
WSClientExplorer >> inspectButton: anObject [
	inspectButton := anObject
]

{ #category : #actions }
WSClientExplorer >> inspectClient [
	^ apiClient inspect
]

{ #category : #initialization }
WSClientExplorer >> loadParametersForMethod: aMethod [
	params := self paramsWidgetForMethod: aMethod
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
WSClientExplorer >> paramsWidgetForMethod: aMethod [
	| paramsPresenter |
	paramsPresenter := WSEndpointParamsPresenter
		on: aMethod methodClass
		withParameters:
			aMethod wsEndpointPath pathString formatTokens
				, aMethod wsEndpointExecutionParams.
	paramsPresenter endpointMethod: aMethod.
	^ self instantiate: paramsPresenter
]

{ #category : #initialization }
WSClientExplorer >> pathDescriptionForMethod: aMethod [
	| str |
	str := aMethod wsEndpointHttpMethod asString asUppercase , ' '
		, aMethod wsEndpointPath pathString.
	str := str , ' >> #' , aMethod selector.
	^ str
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
		add: goButton
]

{ #category : #actions }
WSClientExplorer >> showCurl [
	| endpoint method |
	endpoint := self params endpointClass on: apiClient.
	self params configureOn: endpoint.
	method := pathSelector selectedItem.
	(endpoint curl: [ :http | http method: method wsEndpointHttpMethod asString asUppercase ])
		inspect
]

{ #category : #api }
WSClientExplorer >> title [
	^ apiClient class name , ' Explorer'
]
