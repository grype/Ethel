"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestEthel,
	#superclass : #PackageManifest,
	#category : #'Ethel-Manifest'
}

{ #category : #'code-critics' }
ManifestEthel class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#Ethel)) #'2022-07-03T00:45:33.97343-07:00') )
]
