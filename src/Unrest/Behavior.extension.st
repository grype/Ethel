Extension { #name : #Behavior }

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
