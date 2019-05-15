Extension { #name : #Class }

{ #category : #'*Ethel-Tools' }
Class >> gtInspectorWSEndpointExecutingMethodsIn: composite [
	"This provides a list of all endpoint executing methods"

	<gtInspectorPresentationOrder: 20>
	composite list 
		title: 'Endpoint Methods';
		display: [ (self wsEndpointExecutingMethods collect: #asRingDefinition) 
						sorted: [ :x :y | x selector < y selector ] ];
		format: #selector;
		tags: [ :each | {each methodClass name} ]
]
