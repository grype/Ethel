"
A WSRequestHeaderBuilderTest is a test class for testing the behavior of WSRequestHeaderBuilder
"
Class {
	#name : #WSRequestHeaderBuilderTest,
	#superclass : #TestCase,
	#category : #'Ethel-Tests-Builders'
}

{ #category : #tests }
WSRequestHeaderBuilderTest >> testBuildOnInContext [
	| http temp visitor |

	http := ZnClient new
		        get: 'http://example.com';
		        yourself.
	temp := 'omg'.
	visitor := WSZincTransportVisitor
		           onTransport: http
		           inContext: thisContext.
	WSRequestHeaderBuilder new
		selector: #headerAt:put:;
		headerKey: 'X-Testing';
		headerValue: '{temp}';
		accept: visitor.
	(http request headers at: 'X-Testing') should equal: temp
]
