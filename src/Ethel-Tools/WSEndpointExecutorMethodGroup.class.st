Class {
	#name : #WSEndpointExecutorMethodGroup,
	#superclass : #ClyMethodGroup,
	#category : #'Ethel-Tools-Browser-Plugins'
}

{ #category : #decoration }
WSEndpointExecutorMethodGroup >> decorateTableCell: anItemCellMorph of: groupItem [
	super decorateTableCell: anItemCellMorph of: groupItem.
	anItemCellMorph definitionIcon: #smallJump
]
