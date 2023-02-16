"
I define a behavior for encoding paths on HTTP transport.

I am used to encode paths of `WSPluggableEndpoint`s onto the request URL.
"
Trait {
	#name : #TWSPathEncoder,
	#category : #'Ethel-Core'
}

{ #category : #private }
TWSPathEncoder >> encodePath: aPath on: aTransport [
	self subclassResponsibility 
]
