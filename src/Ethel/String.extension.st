Extension { #name : #String }

{ #category : #'*Ethel' }
String >> asWebClient [
	^ WSDynamicClient withUrl: self asUrl
]
