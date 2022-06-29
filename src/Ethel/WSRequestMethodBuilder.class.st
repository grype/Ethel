"
I configure transport with http method, and, optionally, modify the request path.

I respond to pragmas in the format <method> or <method: 'path/somewhere'>, where method is a valid HTTP method. See my class side on how I validate those methods. Path argument is optional and can be relative or absolute path string. If you need to reference a variable available during execution - use string formatting - e.g. '/something/{id}/blah/blah'. During execution, if there's a variable `id` defined - its value will be substituted.
"
Class {
	#name : #WSRequestMethodBuilder,
	#superclass : #Object,
	#traits : 'TWSTransportBuilder',
	#classTraits : 'TWSTransportBuilder classTrait',
	#instVars : [
		'httpMethod',
		'path'
	],
	#category : #'Ethel-Builders'
}

{ #category : #'instance creation' }
WSRequestMethodBuilder class >> fromPragma: aPragma [
	| httpMethod instance |

	httpMethod := aPragma selector asLowercase copyWithoutAll: ':'.
	(self supportedHttpMethods includes: httpMethod) ifFalse: [ ^ nil ].
	instance := self new.
	instance httpMethod: httpMethod.
	aPragma arguments ifNotEmpty: [ :args | instance path: args first ].
	^ instance
]

{ #category : #accessing }
WSRequestMethodBuilder class >> supportedHttpMethods [

	^ #( #get #post #put #patch #delete #options )
]

{ #category : #building }
WSRequestMethodBuilder >> buildOn: http [
	httpMethod ifNotNil: [ :val | http method: val asUppercase ].
	path ifNotNil: [ :val | 
		| url |

		url := http request url.
		url segments: (Path / url path resolve: val) segments ]
]

{ #category : #accessing }
WSRequestMethodBuilder >> httpMethod [

	^ httpMethod
]

{ #category : #accessing }
WSRequestMethodBuilder >> httpMethod: anObject [

	httpMethod := anObject
]

{ #category : #accessing }
WSRequestMethodBuilder >> path [

	^ path
]

{ #category : #accessing }
WSRequestMethodBuilder >> path: anObject [

	path := anObject
]
