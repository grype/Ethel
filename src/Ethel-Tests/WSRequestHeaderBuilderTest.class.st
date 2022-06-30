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
	| http temp |

	http := ZnClient new
		        get: 'http://example.com';
		        yourself.
	temp := 'omg'.
	WSRequestHeaderBuilder new
		selector: #headerAt:put:;
		headerKey: 'X-Testing';
		headerValue: '{temp}';
		buildOn: http inContext: thisContext.
	(http request headers at: 'X-Testing') should equal: temp
]
