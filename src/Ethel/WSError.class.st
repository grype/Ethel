"
I am a general purpose WSError, but my subclasses are a lot more meaningful.
"
Class {
	#name : #WSError,
	#superclass : #Error,
	#category : #'Ethel-Core'
}

{ #category : #private }
WSError >> isResumable [
	^ true
]
