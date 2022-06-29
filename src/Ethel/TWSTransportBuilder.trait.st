"
I describe a transport builder behavior.

During request execution, the executing method's pragmas are matched to transport builders, which are instantiated via class method `#fromPragma:`, expecting the class to return a configured instance if the class handles given pragma. Then the builder is given a chance to modify the transport (which is an instance of `ZnUrl`) via `#buildOn:` method.
"
Trait {
	#name : #TWSTransportBuilder,
	#category : #'Ethel-Builders'
}

{ #category : #building }
TWSTransportBuilder >> buildOn: http [
	^ self subclassResponsibility
]
