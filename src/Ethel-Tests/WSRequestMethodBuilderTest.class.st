"
A WSRequestMethodBuilderTest is a test class for testing the behavior of WSRequestMethodBuilder
"
Class {
	#name : #WSRequestMethodBuilderTest,
	#superclass : #TestCase,
	#category : #'Ethel-Tests-Builders'
}

{ #category : #tests }
WSRequestMethodBuilderTest >> testBuildMethodAndAbsolutePath [
	| http visitor |

	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.

	visitor := WSZincTransportVisitor
		           onTransport: http
		           inContext: thisContext.
	WSRequestMethodBuilder new
		httpMethod: #get;
		path: Path / 'omg';
		accept: visitor.

	http request method should equal: #GET.
	http request url path should equal:
		'http://example.com/omg' asUrl path
]

{ #category : #tests }
WSRequestMethodBuilderTest >> testBuildMethodAndRelativePath [
	| http visitor |

	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.

	visitor := WSZincTransportVisitor
		           onTransport: http
		           inContext: thisContext.
	WSRequestMethodBuilder new
		httpMethod: #get;
		path: Path * 'omg';
		accept: visitor.

	http request method should equal: #GET.
	http request url path should equal:
		'http://example.com/one/two/omg' asUrl path
]

{ #category : #tests }
WSRequestMethodBuilderTest >> testBuildMethodOnly [
	| http originalPath visitor |

	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.
	originalPath := http request url path.

	visitor := WSZincTransportVisitor
		           onTransport: http
		           inContext: thisContext.
	WSRequestMethodBuilder new
		httpMethod: #get;
		accept: visitor.

	http request method should equal: #GET.
	http request url path should equal: originalPath
]
