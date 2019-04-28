Class {
	#name : #BaselineOfUnrest,
	#superclass : #BaselineOf,
	#category : #BaselineOfUnrest
}

{ #category : #baselines }
BaselineOfUnrest >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec repository: 'github://grype/Unrest/src'.
			self dependencies: spec.
			spec package: #WSClient with: [ spec requires: #('NeoJSON') ].
			spec
				package: #'Unrest-Tests'
				with: [ spec requires: #('WSClient' 'Mocketry') ].
			spec
				package: #'Unrest-Tools'
				with: [ spec requires: #('WSClient' 'Roassal2') ].
			spec
				group: 'default' with: #('WSClient' 'Unrest-Tests');
				group: 'core' with: #('WSClient');
				group: 'tools' with: #('Unrest-Tools') ]
]

{ #category : #baselines }
BaselineOfUnrest >> dependencies: spec [
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
