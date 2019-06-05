Extension { #name : #RTEdgeBuilder }

{ #category : #'*Ethel-Tools' }
RTEdgeBuilder >> addAction: aBlock [
	"aBlock will be passed edge instance as the sole argument"
	actions add: aBlock
]
