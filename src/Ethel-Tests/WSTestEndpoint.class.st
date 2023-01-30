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

{ #category : #'private-executing' }
WSTestEndpoint >> get [
	<get>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsolute [
	<get: '/absolute'>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteDeep [
	<get: '/absolute/deep/path'>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteKeyword: anArgument [
	<get: '/{anArgument}'>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getAbsoluteMixed: anArgument [
	<get: '/absolute/{local}/{anArgument}/path'>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelative [
	<get: 'relative'>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeDeep [
	<get: 'relative/deep/path'>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeKeyword: anArgument [
	<get: '{anArgument}'>
	^ self execute
]

{ #category : #'private-executing' }
WSTestEndpoint >> getRelativeMixed: anArgument [
	<get: 'relative/{local}/{anArgument}/path'>
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
