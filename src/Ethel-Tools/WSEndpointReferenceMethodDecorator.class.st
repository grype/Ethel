Class {
	#name : #WSEndpointReferenceMethodDecorator,
	#superclass : #ClyMethodTableDecorator,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointReferenceMethodDecorator class >> decorateMainTableCell: anItemCellMorph of: aDataSourceItem [
	super decorateMainTableCell: anItemCellMorph of: aDataSourceItem.
	
	anItemCellMorph definitionIcon: #references
]

{ #category : #decoration }
WSEndpointReferenceMethodDecorator class >> decorateTableCell: anItemCellMorph of: aDataSourceItem [

]

{ #category : #testing }
WSEndpointReferenceMethodDecorator class >> wantsDecorateTableCellOf: aDataSourceItem [
	^aDataSourceItem isMarkedWith: WSEndpointReferenceTag 
]
