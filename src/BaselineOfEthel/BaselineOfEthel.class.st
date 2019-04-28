Class {
	#name : #BaselineOfEthel,
	#superclass : #BaselineOf,
	#category : #BaselineOfEthel
}

{ #category : #baselines }
BaselineOfEthel >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec repository: 'github://grype/Unrest/src'.
			self dependencies: spec.
			spec package: #Ethel with: [ spec requires: #('NeoJSON') ].
			spec
				package: #'Ethel-Tests'
				with: [ spec requires: #('Ethel' 'Mocketry') ].
			spec
				package: #'Ethel-Tools'
				with: [ spec requires: #('Ethel' 'Roassal2') ].
			spec
				group: 'default' with: #('Ethel' 'Ethel-Tests');
				group: 'core' with: #('Ethel');
				group: 'tools' with: #('Ethel-Tools') ]
]

{ #category : #baselines }
BaselineOfEthel >> dependencies: spec [
	spec
		baseline: 'Roassal2'
		with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry:v4.0.x' ].
	spec
		baseline: 'NeoJSON';
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]
