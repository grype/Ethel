Class {
	#name : #WSStringInterpolationTest,
	#superclass : #TestCase,
	#instVars : [
		'localVar'
	],
	#category : #'Ethel-Tests-Core'
}

{ #category : #compiler }
WSStringInterpolationTest class >> compiler [ 
	^ super compiler addPlugin: StringInterpolationPlugin 
]

{ #category : #running }
WSStringInterpolationTest >> setUp [
	super setUp.
	localVar := DateAndTime new
]

{ #category : #testing }
WSStringInterpolationTest >> testReferencingLocalVar [
	'{localVar asString asUppercase}' should equal:
		localVar asString asUppercase
]

{ #category : #testing }
WSStringInterpolationTest >> testReferencingPassedArg [
	| temp |

	temp := DateAndTime new.
	(self uppercase: temp) should equal: temp asString asUppercase
]

{ #category : #testing }
WSStringInterpolationTest >> testReferencingTempVar [
	| aTemp |

	aTemp := 'I am a temp'.
	'{aTemp asUppercase}' should equal: aTemp asUppercase
]

{ #category : #testing }
WSStringInterpolationTest >> testUsingPragma [
	<local: '{localVar asString}'>
	<upper: '{#omg asUppercase}'>
	| result |
	result := (thisContext method pragmas collect: [ :aPragma | 
		           aPragma selector
		           ->
		           (aPragma arguments first evaluateForContext: thisContext) ])
		          asDictionary.
	result should equal: { 
			(#local -> localVar asString).
			(#upper -> 'OMG') } asDictionary
]

{ #category : #'private testing' }
WSStringInterpolationTest >> uppercase: anArg [
	^ '{anArg asString asUppercase}'
]
