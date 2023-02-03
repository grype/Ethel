"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestEthel,
	#superclass : #PackageManifest,
	#category : #'Ethel-Manifest'
}

{ #category : #'code-critics' }
ManifestEthel class >> ruleCollectionMessagesToExternalObjectRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#TWSEnumeration #groupedBy: #false)) #'2023-02-02T16:54:42.244054-08:00') #(#(#RGMethodDefinition #(#TWSEnumeration #groupedBy:whileFalse: #false)) #'2023-02-02T20:53:44.124073-08:00') #(#(#RGMethodDefinition #(#TWSEnumeration #groupedBy:whileTrue: #false)) #'2023-02-02T20:53:53.002527-08:00') )
]

{ #category : #'code-critics' }
ManifestEthel class >> ruleCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#TWSEnumeration #groupedBy: #false)) #'2023-02-02T16:53:40.294374-08:00') #(#(#RGMethodDefinition #(#TWSEnumeration #groupedBy:whileFalse: #false)) #'2023-02-02T20:53:47.368318-08:00') #(#(#RGMethodDefinition #(#TWSEnumeration #groupedBy:whileTrue: #false)) #'2023-02-02T20:53:57.665405-08:00') )
]

{ #category : #'code-critics' }
ManifestEthel class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#Ethel)) #'2022-07-03T00:45:33.97343-07:00') )
]
