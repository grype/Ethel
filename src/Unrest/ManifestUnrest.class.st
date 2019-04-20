"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestUnrest,
	#superclass : #PackageManifest,
	#category : #'Unrest-Manifest'
}

{ #category : #'code-critics' }
ManifestUnrest class >> ruleRBUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#WSClient #validateRequest: #false)) #'2018-08-06T19:17:12.83524-07:00') )
]
