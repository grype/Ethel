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
	| someTemp http visitor context |

	someTemp := 'omg'.
	http := ZnClient new
		        get: 'http://example.com';
		        yourself.
	context := WSContext new
		           transport: http;
		           sender: thisContext;
		           yourself.
	WSCurrentContext value: context during: [ 
		visitor := WSZincTransportVisitor new.
		WSRequestQueryBuilder new
			selector: #queryAt:put:;
			queryKey: #foo;
			queryValue: '{someTemp}';
			accept: visitor.
		(http request url queryAt: #foo) should equal: someTemp ]
]
