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

{ #category : #api }
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

{ #category : #api }
WSTestEndpoint >> get [
	<endpoint>
	<get>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getAbsolute [
	<endpoint: '/absolute'>
	<get>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getAbsoluteDeep [
	<endpoint: '/absolute/deep/path'>
	<get>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getAbsoluteKeyword: anArgument [
	<endpoint: '/{anArgument}'>
	<get>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getAbsoluteMixed: anArgument [
	<endpoint: '/absolute/{local}/{anArgument}/path'>
	<get>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getRelative [
	<endpoint: 'relative'>
	<get>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getRelativeDeep [
	<endpoint: 'relative/deep/path'>
	<get>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getRelativeKeyword: anArgument [
	<endpoint: '{anArgument}'>
	<get>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> getRelativeMixed: anArgument [
	<endpoint: 'relative/{local}/{anArgument}/path'>
	<get>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> options [
	<endpoint>
	<options>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> patch [
	<endpoint>
	<patch>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> post [
	<endpoint>
	<post>
	^ self execute
]

{ #category : #api }
WSTestEndpoint >> put [
	<endpoint>
	<put>
	^ self execute
]
