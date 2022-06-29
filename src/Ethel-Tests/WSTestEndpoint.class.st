Class {
	#name : #WSTestEndpoint,
	#superclass : #Object,
	#traits : 'TWSTestEndpoint',
	#classTraits : 'TWSTestEndpoint classTrait',
	#category : #'Ethel-Tests-Models'
}

{ #category : #'private-executing' }
WSTestEndpoint >> delete [
	<delete>
	^ self execute
]

{ #category : #accessing }
WSTestEndpoint >> endpointPath [
	^ Path / 'test'
]

{ #category : #'private-executing' }
WSTestEndpoint >> get [
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsolute [
	<path: '/absolute'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteDeep [
	<path: '/absolute/deep/path'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteKeyword: anArgument [
	<path: '/{anArgument}'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteMixed: anArgument [
	<path: '/absolute/{local}/{anArgument}/path'>
	<get>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelative [
	<path: 'relative'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeDeep [
	<path: 'relative/deep/path'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeKeyword: anArgument [
	<path: '{anArgument}'>
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeMixed: anArgument [
	<path: 'relative/{local}/{anArgument}/path'>
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
	<options>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> patch [
	<patch>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> post [
	<post>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> put [
	<put>
	^ self execute
]
