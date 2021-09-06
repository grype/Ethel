"
I represent a way to access an endpoint on a remote server.

I simply capture the method and a path, like:

> GET /me
> POST /here

Instance variables
- method: capitalized `Symbol`
- path: `Path`
"
Class {
	#name : #WSEndpointAccessor,
	#superclass : #Object,
	#instVars : [
		'method',
		'path'
	],
	#category : #'Ethel-Core'
}

{ #category : #'instance creation' }
WSEndpointAccessor class >> method: aMethodString path: aPath [

	^ self new
		  method: aMethodString;
		  path: aPath;
		  yourself
]

{ #category : #comparing }
WSEndpointAccessor >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ path = anObject path and: [ method = anObject method ]
]

{ #category : #comparing }
WSEndpointAccessor >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ path hash bitXor: method hash
]

{ #category : #accessing }
WSEndpointAccessor >> method [

	^ method
]

{ #category : #accessing }
WSEndpointAccessor >> method: anObject [
	method := anObject ifNotNil: [ :val | 
		          val asString asUppercase asSymbol ]
]

{ #category : #accessing }
WSEndpointAccessor >> path [

	^ path
]

{ #category : #accessing }
WSEndpointAccessor >> path: anObject [
	path := anObject
]
