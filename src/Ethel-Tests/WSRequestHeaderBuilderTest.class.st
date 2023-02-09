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
	| http temp context |

	http := ZnClient new
		  get: 'http://example.com';
		  yourself.
	temp := 'omg'.
	context := WSContext new
		           transport: http;
		           sender: thisContext;
		           yourself.

	WSCurrentContext value: context during: [ 
		WSRequestHeaderBuilder new
			selector: #headerAt:put:;
			headerKey: 'X-Testing';
			headerValue: '{temp}';
			accept: WSZincTransportVisitor new.
		(http request headers at: 'X-Testing') should equal: temp ]
]
