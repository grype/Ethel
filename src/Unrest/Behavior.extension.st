Extension { #name : #Behavior }

{ #category : #'*Unrest' }
Behavior >> collectDerivedWSEndpointsInto: aCollection [
	| result |

	result := (self wsEndpointReferences asSet flatCollect: #value)
		copyWithoutAll: aCollection.
	aCollection addAll: result.
	result
		do: [ :aClass | aClass collectDerivedWSEndpointsInto: aCollection ]
]

{ #category : #'*Unrest' }
Behavior >> derivedWSEndpoints [
	| result |

	result := Set new.
	self collectDerivedWSEndpointsInto: result.
	^ result
]

{ #category : #'*Unrest' }
Behavior >> isWSEndpoint [
	^ self withAllSuperclasses
		contains: [ :each | each traitComposition includesTrait: TWSEndpoint ]
]

{ #category : #'*Unrest' }
Behavior >> wsEndpointExecutingMethods [
	"Returns a collection of executing endpoint methods"
	
	^ self methods select: #isWSEndpointExecutionMethod
]

{ #category : #'*Unrest' }
Behavior >> wsEndpointReferences [
	"Returns a Set of methods and endpoint classes they reference"

	^ (self methods
		collect: [ :aMethod | aMethod -> aMethod wsEndpointReferences ]
		as: Set) reject: [ :each | each value isEmptyOrNil ]
]
