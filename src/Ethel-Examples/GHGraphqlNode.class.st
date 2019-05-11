Class {
	#name : #GHGraphqlNode,
	#superclass : #Object,
	#instVars : [
		'name',
		'parameters',
		'children'
	],
	#category : #'Ethel-Examples-Github-GraphQL'
}

{ #category : #'instance creation' }
GHGraphqlNode class >> named: aName [
	^ self basicNew
		initializeWithName: aName;
		yourself
]

{ #category : #'instance creation' }
GHGraphqlNode class >> named: aName parameters: aDictOfParams children: aCollectionOfChildren [
	| instance |

	instance := self basicNew
		initializeWithName: aName;
		yourself.
	aDictOfParams ifNotNil: [ :val | instance parameters: val asDictionary ].
	aCollectionOfChildren ifNotNil: [ :val | instance children: val asOrderedCollection ].
	^ instance
]

{ #category : #accessing }
GHGraphqlNode >> children [
	^ children
]

{ #category : #accessing }
GHGraphqlNode >> children: anObject [
	children := anObject
]

{ #category : #initialization }
GHGraphqlNode >> initialize [
	super initialize.
	children := OrderedCollection new.
	parameters := Dictionary new
]

{ #category : #initialization }
GHGraphqlNode >> initializeWithName: aString [
	self initialize.
	name := aString
]

{ #category : #accessing }
GHGraphqlNode >> name [
	^ name
]

{ #category : #accessing }
GHGraphqlNode >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GHGraphqlNode >> parameters [
	^ parameters
]

{ #category : #accessing }
GHGraphqlNode >> parameters: anObject [
	parameters := anObject
]

{ #category : #printing }
GHGraphqlNode >> printOn: aStream [
	aStream nextPutAll: name asString.
	parameters
		ifNotEmpty: [ :val | 
			aStream nextPut: $(.
			val associations
				do: [ :each | 
					aStream
						nextPutAll: each key asString;
						nextPutAll: ': '.
					each value isSymbol
						ifTrue: [ aStream nextPutAll: each value asString ]
						ifFalse: [ aStream print: each value ] ]
				separatedBy: [ aStream nextPut: Character space ].
			aStream nextPut: $) ].

	children
		ifNotEmpty: [ :val | 
			aStream nextPutAll: ' { '.
			val
				do: [ :each | 
					each isSymbol
						ifTrue: [ aStream nextPutAll: each asString ]
						ifFalse: [ aStream print: each ] ]
				separatedBy: [ aStream nextPut: Character space ].
			aStream nextPutAll: ' } ' ]
]
