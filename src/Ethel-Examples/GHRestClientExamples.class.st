Class {
	#name : #GHRestClientExamples,
	#superclass : #Object,
	#category : #'Ethel-Examples-Github-REST'
}

{ #category : #'as yet unclassified' }
GHRestClientExamples >> createClient [
	<gtExample>
	^ GHRestClient default
]

{ #category : #'as yet unclassified' }
GHRestClientExamples >> getFewGistFiles [
	<gtExample>
	| client |

	client := self createClient.
	^ client gists public
		select: [ :each | 
			each
				at: #files
				ifPresent: [ :val | val isEmptyOrNil not ]
				ifAbsent: [ false ] ]
		thenFlatCollect: [ :each | each at: #files ]
		max: 10
]

{ #category : #'as yet unclassified' }
GHRestClientExamples >> getFewGists [
	<gtExample>
	| client |

	client := self createClient.
	^ client gists public first: 3
]

{ #category : #'as yet unclassified' }
GHRestClientExamples >> getRecentGistsByLanguage [
	<gtExample>
	| client |

	client := self createClient.
	^ (client gists public
		since: DateAndTime current - 30 minutes;
		select: [ :each | 
			each
				at: #files
				ifPresent: [ :val | val isEmptyOrNil not ]
				ifAbsent: [ false ] ]
			thenFlatCollect: [ :each | each at: #files ])
		groupedBy: [ :each | each at: #language ifAbsent: [ nil ] ]
]

{ #category : #'as yet unclassified' }
GHRestClientExamples >> getUsersPublicGists [
	<gtExample>
	| client |

	client := self createClient.
	^ (UIManager default request: 'Enter Github username')
		ifNotNil: [ :username | client gists publicForUsername: username ]
]
