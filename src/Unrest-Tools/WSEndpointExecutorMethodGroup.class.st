Class {
	#name : #WSEndpointExecutorMethodGroup,
	#superclass : #ClyMethodGroup,
	#category : #'Unrest-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointExecutorMethodGroup >> decorateTableCell: anItemCellMorph of: groupItem [
	super decorateTableCell: anItemCellMorph of: groupItem.
	anItemCellMorph definitionIcon: #smallJump
]
