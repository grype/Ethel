"
I configure transport (`ZnClient`) by adding/setting query parameters
"
Class {
	#name : #WSRequestQueryBuilder,
	#superclass : #Object,
	#traits : 'TWSTransportBuilder',
	#classTraits : 'TWSTransportBuilder classTrait',
	#instVars : [
		'queryValue',
		'queryKey',
		'selector'
	],
	#category : #'Ethel-Builders'
}

{ #category : #'instance creation' }
WSRequestQueryBuilder class >> allowedSelectors [
	^ #( #queryAt:put: #queryAt:add: #queryAt:ifAbsent:
	     #queryAt:ifPresent: )
]

{ #category : #'instance creation' }
WSRequestQueryBuilder class >> fromPragma: aPragma [
	| selector args instance |

	selector := aPragma selector.
	args := aPragma arguments.
	(self allowedSelectors includes: selector) ifFalse: [ ^ nil ].
	instance := self new
		            queryKey: args first asString;
		            queryValue: args last;
		            selector: selector;
		            yourself
]

{ #category : #'building - transport' }
WSRequestQueryBuilder >> buildOn: http inContext: aContext [
	http request url perform: selector withArguments: { 
			queryKey.
			(queryValue format: aContext wsEndpointTemps) }
]

{ #category : #accessing }
WSRequestQueryBuilder >> queryKey [

	^ queryKey
]

{ #category : #accessing }
WSRequestQueryBuilder >> queryKey: anObject [

	queryKey := anObject
]

{ #category : #accessing }
WSRequestQueryBuilder >> queryValue [

	^ queryValue
]

{ #category : #accessing }
WSRequestQueryBuilder >> queryValue: anObject [

	queryValue := anObject
]

{ #category : #accessing }
WSRequestQueryBuilder >> selector [

	^ selector
]

{ #category : #accessing }
WSRequestQueryBuilder >> selector: anObject [

	selector := anObject
]
