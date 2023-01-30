Trait {
	#name : #TGHEndpoint,
	#instVars : [
		'endpointPath'
	],
	#traits : 'TWSEndpoint',
	#classTraits : 'TWSEndpoint classTrait',
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #configuring }
TGHEndpoint >> configureOn: http [

	http request url path segments:
		(wsClient basePath / self endpointPath) segments
]

{ #category : #accessing }
TGHEndpoint >> endpointPath [
	^ self notImplemented 
]
