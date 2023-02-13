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

{ #category : #configuring }
GHGraphqlRootEndpoint >> configure [
	WSCurrentContext value ifNotNil: [ :context | 
		query ifNotNil: [ :val | 
			| q |

			q := GHGraphqlNode named: #query parameters: nil children: { val }.
			context transport contents:
				{ (#query -> q printString) } asDictionary ] ]
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
