Extension { #name : #String }

{ #category : #'*Ethel' }
String >> asWebService [
	^ WSDynamicClient withUrl: self asUrl
]
