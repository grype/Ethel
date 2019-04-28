Class {
	#name : #WSEndpointReferenceMethodGroup,
	#superclass : #ClyMethodGroup,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointReferenceMethodGroup >> decorateTableCell: anItemCellMorph of: groupItem [
	super decorateTableCell: anItemCellMorph of: groupItem.
	anItemCellMorph definitionIcon: #references
]
