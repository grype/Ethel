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
		do: [ spec repository: 'github://cotap/grype-experiments/repository'.
			spec
				project: 'Roassal2'
				with: [ spec
						className: #ConfigurationOfRoassal2;
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main/' ].
			spec package: #Unrest with: [ spec requires: #('Roassal2') ] ]
]
