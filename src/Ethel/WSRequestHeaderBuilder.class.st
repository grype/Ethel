"
I configure transport (`ZnClient`) by setting or adding request header.
"
Class {
	#name : #WSRequestHeaderBuilder,
	#superclass : #Object,
	#traits : 'TWSTransportBuilder',
	#classTraits : 'TWSTransportBuilder classTrait',
	#instVars : [
		'headerValue',
		'headerKey',
		'selector'
	],
	#category : #'Ethel-Builders'
}

{ #category : #'instance creation' }
WSRequestHeaderBuilder class >> allowedSelectors [
	^ #(#headerAt:add: #headerAt:put:)
]

{ #category : #'instance creation' }
WSRequestHeaderBuilder class >> fromPragma: aPragma [
	| selector args instance |

	selector := aPragma selector.
	args := aPragma arguments.
	(self allowedSelectors includes: selector) ifFalse: [ ^ nil ].
	instance := self new
		            headerKey: args first asString;
		            headerValue: args last;
		            selector: selector;
		            yourself
]

{ #category : #'building - transport' }
WSRequestHeaderBuilder >> buildOn: http inContext: aContext [
	http perform: selector withArguments: { 
			headerKey.
			(headerValue format: aContext wsEndpointTemps) }
]

{ #category : #accessing }
WSRequestHeaderBuilder >> headerKey [

	^ headerKey
]

{ #category : #accessing }
WSRequestHeaderBuilder >> headerKey: anObject [

	headerKey := anObject
]

{ #category : #accessing }
WSRequestHeaderBuilder >> headerValue [

	^ headerValue
]

{ #category : #accessing }
WSRequestHeaderBuilder >> headerValue: anObject [

	headerValue := anObject
]

{ #category : #accessing }
WSRequestHeaderBuilder >> selector [

	^ selector
]

{ #category : #accessing }
WSRequestHeaderBuilder >> selector: anObject [

	selector := anObject
]
