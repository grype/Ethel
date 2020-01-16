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
		'inspectButton'
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
		newRow: [ :row | row add: #goButton ]
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
	^ methods asSet sorted: [ :a :b | a wsEndpointPath pathString < b wsEndpointPath pathString ]
]

{ #category : #initialization }
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
		action: [ apiClient inspect ].
	goButton := self newButton
		label: 'Go';
		action: [ self go ].
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
	^ self
		instantiate:
			(WSEndpointParamsPresenter
				on: aMethod methodClass
				withParameters: aMethod wsEndpointPath pathString formatTokens , aMethod wsEndpointExecutionParams)
]

{ #category : #initialization }
WSClientExplorer >> pathDescriptionForMethod: aMethod [
	| str execParams epParams methodParams pathParams |
	str := aMethod wsEndpointHttpMethod asString asUppercase , ' '
		, aMethod wsEndpointPath pathString.
	execParams := aMethod wsEndpointExecutionParams.
	execParams isEmptyOrNil
		ifTrue: [ ^ str ].
	epParams := WSEndpointParamsPresenter
		propertiesFromClass: aMethod methodClass.
	pathParams := aMethod wsEndpointPath pathString formatTokens.
	methodParams := execParams difference: (epParams union: pathParams).
	methodParams isEmptyOrNil
		ifFalse: [ str := str , ' ( +' , (methodParams joinUsing: ' +') , ' )' ].
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

{ #category : #api }
WSClientExplorer >> title [
	^ apiClient class name , ' Explorer'
]
