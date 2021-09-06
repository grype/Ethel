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

{ #category : #actions }
WSClientExplorer >> executeEndpointOn: aClient [
	| endpoint method args |
	endpoint := self params endpointClass on: aClient.
	self params configureOn: endpoint.
	method := pathSelector selectedItem.
	args := method wsEndpointExecutionParams
		collect: [ :each | self params valueFor: each asSymbol ].
	^ endpoint perform: method selector withArguments: args
]

{ #category : #initialization }
WSClientExplorer >> executingMethods [
	| methods |

	methods := apiClient class derivedWSEndpoints flatCollect: [ :each | 
		           each wsEndpointExecutingMethods ].
	^ methods asSet sorted: [ :a :b | 
		  (a wsEndpointPath ifNil: '' ifNotNil: [ :val | val pathString ])
		  < (b wsEndpointPath ifNil: '' ifNotNil: [ :val | val pathString ]) ]
]

{ #category : #actions }
WSClientExplorer >> go [
	(self executeEndpointOn: apiClient) inspect
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

	params := (apiClient httpClientOnEndpoint: aMethod methodClass new)
		          request url asString urlDecoded formatTokens.
	params addAll: aMethod wsEndpointExecutionParams.
	paramsPresenter := WSEndpointParamsPresenter
		                   on: aMethod methodClass
		                   withParameters: params.
	paramsPresenter endpointMethod: aMethod.
	^ self instantiate: paramsPresenter
]

{ #category : #initialization }
WSClientExplorer >> pathDescriptionForMethod: aMethod [
	| str accessor http |

	accessor := aMethod wsEndpointAccessor.
	http := apiClient httpClientOnEndpoint: aMethod methodClass new.
	str := accessor method asUppercase , ' ' , http request url path.
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
	| client |
	"Stub out #createHttpClient so that we can return our own version of ZnClient, with stubbed #execute method, which simply returns a block returning the curl string for the configured client"
	client := apiClient copy.
	(client stub httpClientOnEndpoint: Any)
		willReturn:
			(ZnClient new
				in: [ :http | 
					client configureOn: http.
					http stub execute willReturn: [ http curl ].
					http ]).
	"Stub validation methods as well - we don't care about validating request and the response will most certainly fail since there will be no actual request execution"
	(client stub validateRequest: [ :obj |  ]) willReturn: true.
	(client stub validateResponse: [ :obj |  ]) willReturn: true.

	"Go on like we normally would, evaluating the block returned by the stubbed #execute"
	(self executeEndpointOn: client) value inspect
]

{ #category : #api }
WSClientExplorer >> title [
	^ apiClient class name , ' Explorer'
]
