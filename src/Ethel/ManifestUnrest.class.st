"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestUnrest,
	#superclass : #PackageManifest,
	#category : #'Ethel-Manifest'
}

{ #category : #'code-critics' }
ManifestUnrest class >> ruleRBUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#WSClient #validateRequest: #false)) #'2018-08-06T19:17:12.83524-07:00') )
]

{ #category : #'code-critics' }
ManifestUnrest class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#WSClient)) #'2022-06-26T21:23:12.024633-07:00') )
]
