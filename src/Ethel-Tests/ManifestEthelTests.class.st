"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestEthelTests,
	#superclass : #PackageManifest,
	#category : #'Ethel-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestEthelTests class >> ruleNoClassCommentRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#WSTestClient)) #'2023-02-15T22:27:21.933176-08:00') )
]

{ #category : #'code-critics' }
ManifestEthelTests class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'Ethel-Tests')) #'2022-06-29T21:49:19.3163-07:00') )
]
