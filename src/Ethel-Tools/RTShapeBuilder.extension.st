Extension { #name : #RTShapeBuilder }

{ #category : #'*Ethel-Tools' }
RTShapeBuilder >> doubleArrowedBezier [
	self shape: (RTDoubleArrowedLine new line: RTBezier3Line new).
]
