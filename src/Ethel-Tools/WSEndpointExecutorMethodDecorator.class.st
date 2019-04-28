Class {
	#name : #WSEndpointExecutorMethodDecorator,
	#superclass : #ClyMethodTableDecorator,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointExecutorMethodDecorator class >> decorateMainTableCell: anItemCellMorph of: aDataSourceItem [
	super decorateMainTableCell: anItemCellMorph of: aDataSourceItem.
	
	anItemCellMorph definitionIcon: #protocolPublic
]

{ #category : #decoration }
WSEndpointExecutorMethodDecorator class >> decorateTableCell: anItemCellMorph of: aDataSourceItem [

]

{ #category : #testing }
WSEndpointExecutorMethodDecorator class >> wantsDecorateTableCellOf: aDataSourceItem [
	^aDataSourceItem isMarkedWith: WSEndpointExecutorTag  
]
