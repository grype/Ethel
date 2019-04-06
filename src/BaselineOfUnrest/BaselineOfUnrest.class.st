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
			spec
				baseline: 'Roassal2'
				with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
			spec package: #Unrest.
			spec package: #'Unrest-Tests' with: [ spec requires: #('Unrest') ].
			spec
				package: #'Unrest-Tools'
				with: [ spec requires: #('Unrest' 'Roassal2') ].
			spec
				group: 'default' with: #('Unrest' 'Unrest-Tests');
				group: 'core' with: #('Unrest');
				group: 'tools' with: #('Unrest-Tools') ]
]
