Extension { #name : #Behavior }

{ #category : #'*Ethel' }
Behavior >> collectDerivedWSEndpointsInto: aCollection [
	| result |

	result := (self wsEndpointReferences asSet flatCollect: #value)
		copyWithoutAll: aCollection.
	result := result reject: [ :each | each isTrait ].
	aCollection addAll: result.
	result
		do: [ :aClass | aClass collectDerivedWSEndpointsInto: aCollection ]
]

{ #category : #'*Ethel' }
Behavior >> derivedWSEndpoints [
	| result |

	result := Set new.
	self collectDerivedWSEndpointsInto: result.
	^ result
]

{ #category : #'*Ethel' }
Behavior >> isWSEndpoint [
	^ self withAllSuperclasses
		anySatisfy: [ :each | each traitComposition includesTrait: TWSEndpoint ]
]

{ #category : #'*Ethel' }
Behavior >> wsEndpointExecutingMethods [
	"Returns a collection of executing endpoint methods"
	
	^ self methods select: #isWSEndpointExecutionMethod
]

{ #category : #'*Ethel' }
Behavior >> wsEndpointReferences [
	"Returns a Set of methods and endpoint classes they reference"

	^ (self methods
		collect: [ :aMethod | aMethod -> aMethod wsEndpointReferences ]
		as: Set) reject: [ :each | each value isEmptyOrNil ]
]
