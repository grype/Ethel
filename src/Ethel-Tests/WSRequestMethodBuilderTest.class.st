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
	| builder http |

	builder := WSRequestMethodBuilder new
		           httpMethod: #get;
		           path: Path / 'omg';
		           yourself.
	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.
	builder buildOn: http.
	http request method should equal: #GET.
	http request url path should equal: 'http://example.com/omg' asUrl path
]

{ #category : #tests }
WSRequestMethodBuilderTest >> testBuildMethodAndRelativePath [
	| builder http |

	builder := WSRequestMethodBuilder new
		           httpMethod: #get;
		           path: Path * 'omg';
		           yourself.
	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.
	builder buildOn: http.
	http request method should equal: #GET.
	http request url path should equal:
		'http://example.com/one/two/omg' asUrl path
]

{ #category : #tests }
WSRequestMethodBuilderTest >> testBuildMethodOnly [
	| builder http originalPath |

	builder := WSRequestMethodBuilder new
		           httpMethod: #get;
		           yourself.
	http := ZnClient new
		        url: 'http://example.com/one/two' asUrl;
		        yourself.
	originalPath := http request url path.
	builder buildOn: http.
	http request method should equal: #GET.
	http request url path should equal: originalPath
]
