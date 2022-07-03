Extension { #name : #Collection }

{ #category : #'*Ethel' }
Collection >> compactCollect: aBlock [ 
	^ self compactCollect: aBlock as: self species
]

{ #category : #'*Ethel' }
Collection >> compactCollect: aBlock as: aCollectionClass [
	| col |

	col := OrderedCollection new: self size.
	self
		select: [ :each | each isNotNil ]
		thenDo: [ :each | col addAll: (aBlock value: each) ].
	^ aCollectionClass withAll: col
]
