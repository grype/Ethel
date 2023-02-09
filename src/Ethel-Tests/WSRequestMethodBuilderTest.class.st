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
	| http context |

	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.

	context := WSContext new
		           transport: http;
		           sender: thisContext;
		           yourself.

	WSCurrentContext value: context during: [ 
		WSRequestMethodBuilder new
			httpMethod: #get;
			path: Path / 'omg';
			accept: WSZincTransportVisitor new.
		http request method should equal: #GET.
		http request url path should equal:
			'http://example.com/omg' asUrl path ]
]

{ #category : #tests }
WSRequestMethodBuilderTest >> testBuildMethodAndRelativePath [
	| http context |

	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.

	context := WSContext new
		           transport: http;
		           sender: thisContext;
		           yourself.

	WSCurrentContext value: context during: [ 
		WSRequestMethodBuilder new
			httpMethod: #get;
			path: Path * 'omg';
			accept: WSZincTransportVisitor new.

		http request method should equal: #GET.
		http request url path should equal:
			'http://example.com/one/two/omg' asUrl path ]
]

{ #category : #tests }
WSRequestMethodBuilderTest >> testBuildMethodOnly [
	| http originalPath context |

	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.
	originalPath := http request url path.

	context := WSContext new
		           transport: http;
		           sender: thisContext;
		           yourself.

	WSCurrentContext value: context during: [ 
		WSRequestMethodBuilder new
			httpMethod: #get;
			accept: WSZincTransportVisitor new.

		http request method should equal: #GET.
		http request url path should equal: originalPath ]
]
