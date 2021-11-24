Extension { #name : #WSClient }

{ #category : #'*Ethel-Tools' }
WSClient >> buildMapOn: aBuilder [
	| map |

	map := WSMap onClient: self.
	map buildMapOn: aBuilder
]

{ #category : #'*Ethel-Tools' }
WSClient class >> wsUmlSortOrder [
	^ 1
]
