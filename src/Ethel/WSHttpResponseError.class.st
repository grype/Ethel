"
I represent a response error. I am typically raised by ==WSClient>>#validateResponse:== method to indicate a response error at HTTP level - so think HTTP codes in 400/500's

Instance Variables
	response:		<ZnResponse>
"
Class {
	#name : #WSHttpResponseError,
	#superclass : #WSError,
	#instVars : [
		'response'
	],
	#category : #'Ethel-Core'
}

{ #category : #exceptioninstantiator }
WSHttpResponseError class >> signal: aResponse [
	^ self new
		response: aResponse;
		signal:
			('{1}: {2}'
				format:
					{aResponse statusLine code.
					aResponse statusLine reason})
]

{ #category : #accessing }
WSHttpResponseError >> response [
	^ response
]

{ #category : #accessing }
WSHttpResponseError >> response: anObject [
	response := anObject
]
