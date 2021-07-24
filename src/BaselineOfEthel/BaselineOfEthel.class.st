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
		do: [ spec repository: 'github://grype/Ethel'.
			self dependencies: spec.
			spec package: #Ethel with: [ spec requires: #('NeoJSON') ].
			spec
				package: #'Ethel-Tests'
				with: [ spec requires: #('Ethel' 'Mocketry') ].
			spec
				package: #'Ethel-Tools'
				with: [ spec requires: #('Ethel' 'Mocketry') ].
			spec package: #'Ethel-Examples' with: [ spec requires: #('Ethel') ].
			spec
				group: 'default'
					with: #('Ethel' 'Ethel-Tests' 'Ethel-Tools' 'Ethel-Examples');
				group: 'core' with: #('Ethel');
				group: 'tests' with: #('Ethel-Tests');
				group: 'tools' with: #('Ethel-Tools');
				group: 'examples' with: #('Ethel-Examples') ]
]

{ #category : #baselines }
BaselineOfEthel >> dependencies: spec [
	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry:v4.0.x' ].
	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]
