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

{ #category : #'as yet unclassified' }
WSTestEndpoint class >> referencingPathsWithMethods [
	^ ((WSClient endpointMethodsOn: self)
		collect: [ :aMethod | 
			aMethod
				->
					((aMethod key pragmaAt: #endpoint:)
						ifNil: [ self endpointPath ]
						ifNotNil: [ :val | self endpointPath / val arguments first ]) ]) asSet
]

{ #category : #api }
WSTestEndpoint >> delete [
	<endpoint>
	<delete>
	^ self execute
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
