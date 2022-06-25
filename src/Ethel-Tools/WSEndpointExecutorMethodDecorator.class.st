Class {
	#name : #WSEndpointExecutorMethodDecorator,
	#superclass : #ClyMethodTableDecorator,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointExecutorMethodDecorator class >> decorateMainTableCell: anItemCellMorph of: aDataSourceItem [

	| httpMethod iconMap |
	super decorateMainTableCell: anItemCellMorph of: aDataSourceItem.

	httpMethod := aDataSourceItem actualObject wsEndpointHttpMethod.
	iconMap := { 
		           (#get -> #testGreen).
		           (#post -> #testYellow).
		           (#put -> #testYellow).
		           (#delete -> #testRed) } asDictionary.
	anItemCellMorph definitionIcon:
		(iconMap at: httpMethod ifAbsent: #testNotRun)
]

{ #category : #decoration }
WSEndpointExecutorMethodDecorator class >> decorateTableCell: anItemCellMorph of: aDataSourceItem [

]

{ #category : #testing }
WSEndpointExecutorMethodDecorator class >> wantsDecorateTableCellOf: aDataSourceItem [
	^aDataSourceItem isMarkedWith: WSEndpointExecutorTag  
]
