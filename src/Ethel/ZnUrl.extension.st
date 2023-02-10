Extension { #name : #ZnUrl }

{ #category : #'*Ethel' }
ZnUrl >> asWebClient [
	^ WSDynamicClient withUrl: self
]
