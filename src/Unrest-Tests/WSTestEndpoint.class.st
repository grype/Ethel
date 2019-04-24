Class {
	#name : #WSTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSTestEndpoint',
	#classTraits : 'TWSTestEndpoint classTrait',
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
WSTestEndpoint class >> endpointPath [
	^ Path / 'test'
]

{ #category : #'private-executing' }
WSTestEndpoint >> delete [
	<endpoint>
	<delete>
	^ self execute
]

{ #category : #executing }
WSTestEndpoint >> executingContext [
	| sender |

	sender := thisContext sender.
	[ sender isNotNil and: [ sender method isWSEndpointExecutionMethod not ] ]
		whileTrue: [ sender := sender sender ].

	^ sender
]

{ #category : #'private-executing' }
WSTestEndpoint >> get [
	<endpoint>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsolute [
	<endpoint: '/absolute'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteDeep [
	<endpoint: '/absolute/deep/path'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteKeyword: anArgument [
	<endpoint: '/{anArgument}'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteMixed: anArgument [
	<endpoint: '/absolute/{local}/{anArgument}/path'>
	<get>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelative [
	<endpoint: 'relative'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeDeep [
	<endpoint: 'relative/deep/path'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeKeyword: anArgument [
	<endpoint: '{anArgument}'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeMixed: anArgument [
	<endpoint: 'relative/{local}/{anArgument}/path'>
	<get>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #'accessing structure variables' }
WSTestEndpoint >> nested [
	^ self / WSNestedTestEndpoint 
]

{ #category : #'private-executing' }
WSTestEndpoint >> options [
	<endpoint>
	<options>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> patch [
	<endpoint>
	<patch>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> post [
	<endpoint>
	<post>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> put [
	<endpoint>
	<put>
	^ self execute
]
