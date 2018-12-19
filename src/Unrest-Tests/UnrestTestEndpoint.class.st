Class {
	#name : #UnrestTestEndpoint,
	#superclass : #UnrestAbstractTestEndpoint,
	#category : #'Unrest-Tests-Models'
}

{ #category : #accessing }
UnrestTestEndpoint class >> endpointPath [
	^ Path / 'test'
]

{ #category : #api }
UnrestTestEndpoint >> delete [
	<endpoint>
	<delete>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> get [
	<endpoint>
	<get>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getAbsolute [
	<endpoint: '/absolute'>
	<get>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getAbsoluteDeep [
	<endpoint: '/absolute/deep/path'>
	<get>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getAbsoluteKeyword: anArgument [
	<endpoint: '/{anArgument}'>
	<get>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getAbsoluteMixed: anArgument [
	<endpoint: '/absolute/{local}/{anArgument}/path'>
	<get>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getRelative [
	<endpoint: 'relative'>
	<get>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getRelativeDeep [
	<endpoint: 'relative/deep/path'>
	<get>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getRelativeKeyword: anArgument [
	<endpoint: '{anArgument}'>
	<get>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> getRelativeMixed: anArgument [
	<endpoint: 'relative/{local}/{anArgument}/path'>
	<get>
	| local |
	local := 'mixed'.
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> options [
	<endpoint>
	<options>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> patch [
	<endpoint>
	<patch>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> post [
	<endpoint>
	<post>
	^ self execute
]

{ #category : #api }
UnrestTestEndpoint >> put [
	<endpoint>
	<put>
	^ self execute
]
