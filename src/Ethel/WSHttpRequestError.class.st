"
I represent a request error. I am typically raised by ==WSClient>>#validateRequest:== method to indicate an incomplete HTTP request

Instance Variables
	request:		<ZnRequest>
"
Class {
	#name : #WSHttpRequestError,
	#superclass : #WSError,
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

{ #category : #accessing }
WSHttpRequestError >> request [
	^ request
]

{ #category : #accessing }
WSHttpRequestError >> request: anObject [
	request := anObject
]
