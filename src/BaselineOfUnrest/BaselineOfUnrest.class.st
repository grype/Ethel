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
				project: 'Roassal2'
				with: [ spec
						className: #ConfigurationOfRoassal2;
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main/' ].
			spec package: #Unrest.
			spec package: #'Unrest-Tools' with: [ spec requires: #('Unrest' 'Roassal2') ].
			spec
				group: 'default' with: #('Unrest');
				group: 'development' with: #('Unrest' 'Unrest-Tools') ]
]
