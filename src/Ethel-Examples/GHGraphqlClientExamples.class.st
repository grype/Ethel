Class {
	#name : #GHGraphqlClientExamples,
	#superclass : #Object,
	#category : #'Ethel-Examples-Github-GraphQL'
}

{ #category : #'as yet unclassified' }
GHGraphqlClientExamples >> createClient [
	<gtExample>
	^ GHGraphqlClient default
]

{ #category : #'as yet unclassified' }
GHGraphqlClientExamples >> queryFewGistFiles [
	<gtExample>
	| client gists result |

	client := self createClient.
	gists := GHGraphqlNode
		named: #gists
		parameters:
			{(#first -> 10).
			(#privacy -> #ALL)}
		children:
			{(GHGraphqlNode
				named: #edges
				parameters: nil
				children:
					{(GHGraphqlNode
						named: #node
						parameters: nil
						children:
							{(GHGraphqlNode
								named: #files
								parameters: {(#limit -> 10)}
								children:
									{#name.
									(GHGraphqlNode
										named: #language
										parameters: nil
										children: #(#name)).
									#text})})})}.
	result := client
		query: (GHGraphqlNode named: #viewer parameters: nil children: {gists}).

	^ ((((result at: #data) at: #viewer) at: #gists) at: #edges)
		flatCollect: [ :each | (each at: #node) at: #files ]
]

{ #category : #'as yet unclassified' }
GHGraphqlClientExamples >> queryFewGists [
	<gtExample>
	| client gists result |

	client := self createClient.
	gists := GHGraphqlNode
		named: #gists
		parameters:
			{(#first -> 10).
			(#privacy -> #PUBLIC)}
		children:
			{(GHGraphqlNode
				named: #edges
				parameters: nil
				children:
					{(GHGraphqlNode
						named: #node
						parameters: nil
						children: {#id . #description . #name})})}.
	result := client
		query: (GHGraphqlNode named: #viewer parameters: nil children: {gists}).

	^ (((result at: #data) at: #viewer) at: #gists) at: #edges
]
