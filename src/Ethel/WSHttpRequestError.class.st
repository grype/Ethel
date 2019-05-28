Class {
	#name : #WSHttpRequestError,
	#superclass : #Error,
	#instVars : [
		'request'
	],
	#category : #'Ethel-Core'
}

{ #category : #exceptioninstantiator }
WSHttpRequestError class >> signal: aRequest [
	(self basicNew initializeWithRequest: aRequest) signal
]

{ #category : #initialization }
WSHttpRequestError >> initializeWithHttp: anHttp [
	self initialize.
	request := anHttp.
	messageText := 'Invalid HTTP Request'
]

{ #category : #initialization }
WSHttpRequestError >> initializeWithRequest: aRequest [
	self initialize.
	request := aRequest.
	messageText := 'Invalid HTTP Request'
]

{ #category : #private }
WSHttpRequestError >> isResumable [
	^ true
]

{ #category : #accessing }
WSHttpRequestError >> request [
	^ request
]
