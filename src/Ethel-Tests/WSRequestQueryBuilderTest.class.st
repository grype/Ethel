"
A WSRequestQueryBuilderTest is a test class for testing the behavior of WSRequestQueryBuilder
"
Class {
	#name : #WSRequestQueryBuilderTest,
	#superclass : #TestCase,
	#category : #'Ethel-Tests-Builders'
}

{ #category : #tests }
WSRequestQueryBuilderTest >> testBuildOnInContext [
	| someTemp http visitor |

	someTemp := 'omg'.
	http := ZnClient new
		        get: 'http://example.com' asUrl;
		        yourself.
	visitor := WSZincTransportVisitor
		           onTransport: http
		           inContext: thisContext.
	WSRequestQueryBuilder new
		selector: #queryAt:put:;
		queryKey: #foo;
		queryValue: '{someTemp}';
		accept: visitor.
	(http request url queryAt: #foo) should equal: someTemp
]
