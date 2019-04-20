Extension { #name : #Behavior }

{ #category : #'*Unrest' }
Behavior >> isWSEndpoint [
	^ self withAllSuperclasses
		detect: [ :each | each traitComposition includesTrait: TWSEndpoint ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #'*Unrest' }
Behavior >> wsEndpointMethods [
	"Returns a Set of methods that yield to an endpoint"

	^ ((self methods reject: #isFromTrait)
		collect: [ :aMethod | 
			aMethod
				->
					(aMethod allLiterals
						select:
							[ :aLiteral | aLiteral value isClass and: [ aLiteral value isWSEndpoint ] ]) ]
		as: Set) select: [ :each | each value isNotEmpty ]
]
