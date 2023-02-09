Extension { #name : #ZnUrl }

{ #category : #'*Ethel' }
ZnUrl >> asWebService [
	^ WSDynamicClient withUrl: self
]
