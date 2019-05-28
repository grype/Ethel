Class {
	#name : #WSHttpResponseError,
	#superclass : #Error,
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

{ #category : #private }
WSHttpResponseError >> isResumable [
	^ true
]

{ #category : #accessing }
WSHttpResponseError >> response [
	^ response
]

{ #category : #accessing }
WSHttpResponseError >> response: anObject [
	response := anObject
]
