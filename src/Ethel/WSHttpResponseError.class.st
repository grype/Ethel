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
	(self basicNew initializeWithResponse: aResponse) signal
]

{ #category : #initialization }
WSHttpResponseError >> initializeWithHttp: anHttp [
	self initialize.
	response := anHttp.
	messageText := '{1}: {2}'
		format:
			{response response statusLine code.
			response response statusLine reason}
]

{ #category : #initialization }
WSHttpResponseError >> initializeWithResponse: aResponse [
	self initialize.
	response := aResponse.
	messageText := '{1}: {2}'
		format:
			{aResponse statusLine code.
			aResponse statusLine reason}
]

{ #category : #private }
WSHttpResponseError >> isResumable [
	^ true
]

{ #category : #accessing }
WSHttpResponseError >> response [
	^ response
]
