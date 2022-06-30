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
	| someTemp instance http |

	someTemp := 'omg'.
	instance := WSRequestQueryBuilder new
		            selector: #queryAt:put:;
		            queryKey: #foo;
		            queryValue: '{someTemp}';
		            yourself.
	http := ZnClient new
		        get: 'http://example.com' asUrl;
		        yourself.
	instance buildOn: http inContext: thisContext.
	(http request url queryAt: #foo) should equal: someTemp
]
