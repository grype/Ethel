Class {
	#name : #WSEndpointExecutorMethodDecorator,
	#superclass : #ClyMethodTableDecorator,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointExecutorMethodDecorator class >> decorateMainTableCell: anItemCellMorph of: aDataSourceItem [
	| icon |
	super decorateMainTableCell: anItemCellMorph of: aDataSourceItem.
	
	icon := anItemCellMorph definitionIcon: #protocolPublic.
	icon setBalloonText: 'method executes endpoint'
]

{ #category : #decoration }
WSEndpointExecutorMethodDecorator class >> decorateTableCell: anItemCellMorph of: aDataSourceItem [

]

{ #category : #testing }
WSEndpointExecutorMethodDecorator class >> wantsDecorateTableCellOf: aDataSourceItem [
	^aDataSourceItem isMarkedWith: WSEndpointExecutorTag  
]
