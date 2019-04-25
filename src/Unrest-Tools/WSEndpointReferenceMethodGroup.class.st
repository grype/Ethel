Class {
	#name : #WSEndpointReferenceMethodGroup,
	#superclass : #ClyMethodGroup,
	#category : #'Unrest-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointReferenceMethodGroup >> decorateTableCell: anItemCellMorph of: groupItem [
	super decorateTableCell: anItemCellMorph of: groupItem.
	anItemCellMorph definitionIcon: #references
]
