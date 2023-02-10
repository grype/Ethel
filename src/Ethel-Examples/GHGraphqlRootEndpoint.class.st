Class {
	#name : #GHGraphqlRootEndpoint,
	#superclass : #Object,
	#traits : 'TWSEndpoint',
	#classTraits : 'TWSEndpoint classTrait',
	#instVars : [
		'query'
	],
	#category : #'Ethel-Examples-Github-GraphQL'
}

{ #category : #'as yet unclassified' }
GHGraphqlRootEndpoint >> configureOn: http [
	query
		ifNotNil: [ :val | 
			| q |

			q := GHGraphqlNode named: #query parameters: nil children: {val}.
			http contents: {(#query -> q printString)} asDictionary ]
]

{ #category : #executing }
GHGraphqlRootEndpoint >> execute [
	<post>
	^ wsClient execute: self
]

{ #category : #accessing }
GHGraphqlRootEndpoint >> query [
	^ query
]

{ #category : #accessing }
GHGraphqlRootEndpoint >> query: anObject [
	query := anObject
]
