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
	^ self new
		request: aRequest;
		signal: 'Invalid HTTP Request'
]

{ #category : #private }
WSHttpRequestError >> isResumable [
	^ true
]

{ #category : #accessing }
WSHttpRequestError >> request [
	^ request
]

{ #category : #accessing }
WSHttpRequestError >> request: anObject [
	request := anObject
]
