"
I create a form-like UI for configuring endpoint parameters based on ivars that have setters, and any arbitrary set of parameters.

Example:

(WSEndpointParamsPresenter on: MyEndpointClass withParameters: #(#foo #bar)) openWithSpec
"
Class {
	#name : #WSEndpointParamsPresenter,
	#superclass : #DynamicComposablePresenter,
	#instVars : [
		'endpointClass',
		'endpointMethod',
		'spacer',
		'classNameLabel',
		'browseButton',
		'inspectButton',
		'umlButton',
		'showsClassDescription',
		'params'
	],
	#category : #'Ethel-Tools-Widgets'
}

{ #category : #'instance creation' }
WSEndpointParamsPresenter class >> on: aClass [
	^ self on: aClass withParameters: nil
]

{ #category : #'instance creation' }
WSEndpointParamsPresenter class >> on: aClass withParameters: params [
	^ self basicNew
		params: params;
		endpointClass: aClass;
		initialize
]

{ #category : #initialization }
WSEndpointParamsPresenter class >> propertiesFromClass: aClass [
	| classes |
	classes := (aClass withAllSuperclasses select: #isWSEndpoint)
		copyWithout: CdEndpoint.
	^ (classes flatCollect: #instVarNames)
		select: [ :each | aClass canUnderstand: (each , ':') asSymbol ]
]

{ #category : #accessing }
WSEndpointParamsPresenter >> browseButton [
	^ browseButton
]

{ #category : #accessing }
WSEndpointParamsPresenter >> browseButton: anObject [
	browseButton := anObject
]

{ #category : #accessing }
WSEndpointParamsPresenter >> classNameLabel [
	^ classNameLabel
]

{ #category : #accessing }
WSEndpointParamsPresenter >> classNameLabel: anObject [
	classNameLabel := anObject
]

{ #category : #configuring }
WSEndpointParamsPresenter >> configureOn: anEndpoint [
	params
		do: [ :each | 
			| selector |
			selector := (each , ':') asSymbol.
			(anEndpoint respondsTo: selector)
				ifTrue: [ anEndpoint perform: selector with: (self valueFor: each) ] ]
]

{ #category : #accessing }
WSEndpointParamsPresenter >> endpointClass [
	^ endpointClass
]

{ #category : #accessing }
WSEndpointParamsPresenter >> endpointClass: anObject [
	endpointClass := anObject.
	params addAll: (self class propertiesFromClass: anObject)
]

{ #category : #accessing }
WSEndpointParamsPresenter >> endpointMethod [
	^ endpointMethod
]

{ #category : #accessing }
WSEndpointParamsPresenter >> endpointMethod: anObject [
	endpointMethod := anObject
]

{ #category : #initialization }
WSEndpointParamsPresenter >> initializeParamWidgets [
	self sortedParams
		do: [ :var | 
			| label input |
			label := self newLabel
				label: var;
				yourself.
			(endpointClass canUnderstand: (var , ':') asSymbol)
				ifFalse: [ label emphasis: #italic ].
			self assign: label to: (var , '_label') asSymbol.
			input := self newTextInput
				autoAccept: true;
				yourself.
			self assign: input to: (var , '_input') asSymbol.
			self focusOrder add: input ]
]

{ #category : #initialization }
WSEndpointParamsPresenter >> initializeWidgets [
	showsClassDescription := true.
	self initializeParamWidgets.
	classNameLabel := self newLabel
		label: self endpointClass name;
		emphasis: #bold;
		yourself.
	browseButton := self newButton
		icon: (self iconNamed: #glamorousBrowse);
		action: [ (self endpointMethod ifNil: [ self endpointClass ]) browse ];
		yourself.
	inspectButton := self newButton
		icon: (self iconNamed: #smallInspectIt);
		action: [ self instance inspect ];
		yourself.
	umlButton := self newButton
		icon: (self iconNamed: #hierarchy);
		action: [ self showUml ];
		yourself.
	spacer := self newNullPresenter
]

{ #category : #accessing }
WSEndpointParamsPresenter >> inspectButton [
	^ inspectButton
]

{ #category : #accessing }
WSEndpointParamsPresenter >> inspectButton: anObject [
	inspectButton := anObject
]

{ #category : #initialization }
WSEndpointParamsPresenter >> instance [
	| instance |
	instance := endpointClass new.
	params
		do: [ :each | 
			| selector |
			selector := (each , ':') asSymbol.
			(instance respondsTo: selector)
				ifTrue: [ instance perform: selector with: (self valueFor: each) ] ].
	^ instance
]

{ #category : #initialization }
WSEndpointParamsPresenter >> layout [
	| labelWidth longestLabel |
	layout := SpecColumnLayout composed.
	longestLabel := params isEmptyOrNil
		ifTrue: [ '' ]
		ifFalse: [ (params sorted: [ :a :b | a size < b size ]) last ].
	labelWidth := (StringMorph contents: longestLabel) measureContents x
		min: 120.
	labelWidth := labelWidth + 8.
	showsClassDescription
		ifTrue: [ | col |
			col := SpecRowLayout composed.
			col
				add: #classNameLabel;
				add: #inspectButton width: self class toolbarHeight;
				add: #umlButton width: self class toolbarHeight;
				add: #browseButton width: self class toolbarHeight.
			layout add: col height: self class toolbarHeight ].
	self sortedParams
		do: [ :var | 
			| col |
			col := SpecRowLayout composed.
			col
				add: (var , '_label') asSymbol width: labelWidth;
				add: (var , '_input') asSymbol.
			layout add: col height: self class toolbarHeight ].
	layout add: #spacer height: 1.
	^ layout
]

{ #category : #accessing }
WSEndpointParamsPresenter >> params [
	^ params
]

{ #category : #accessing }
WSEndpointParamsPresenter >> params: anObject [
	params := anObject
		ifNil: [ Set new ]
		ifNotNil: [ (anObject collect: #asSymbol) asSet ]
]

{ #category : #accessing }
WSEndpointParamsPresenter >> paramsWithValues [
	^ (params collect: [ :each | each -> (self valueFor: each) ]) asDictionary
]

{ #category : #initialization }
WSEndpointParamsPresenter >> showUml [
	| builder uml |
	builder := WSUMLBuilder new.
	uml := WSUml onEndpointClass: self endpointClass.
	uml selectedObject: self endpointClass.
	uml buildOn: builder.
	builder inspect
]

{ #category : #accessing }
WSEndpointParamsPresenter >> showsClassDescription [
	^ showsClassDescription
]

{ #category : #accessing }
WSEndpointParamsPresenter >> showsClassDescription: anObject [
	showsClassDescription := anObject
]

{ #category : #initialization }
WSEndpointParamsPresenter >> sortedParams [
	^ params sorted: [ :a :b | a < b ]
]

{ #category : #accessing }
WSEndpointParamsPresenter >> spacer [
	^ spacer
]

{ #category : #accessing }
WSEndpointParamsPresenter >> spacer: anObject [
	spacer := anObject
]

{ #category : #accessing }
WSEndpointParamsPresenter >> umlButton [
	^ umlButton
]

{ #category : #accessing }
WSEndpointParamsPresenter >> umlButton: anObject [
	umlButton := anObject
]

{ #category : #initialization }
WSEndpointParamsPresenter >> valueFor: aVarName [
	| widget value |
	widget := widgets at: (aVarName , '_input') asSymbol.
	value := self class evaluate: widget text.
	^ value
]
