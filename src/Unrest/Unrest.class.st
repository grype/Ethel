Class {
	#name : #Unrest,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'contentReader',
		'contentWriter'
	],
	#category : #'Unrest-Core'
}

{ #category : #introspection }
Unrest class >> associatedEndpointClasses [
	| methods referencedClasses rootEndpointClass |

	methods := self endpointMethods.
	referencedClasses := ((methods flatCollect: [ :each | each value ])
		collect: #value) asSet.
	rootEndpointClass := (referencedClasses
		flatCollect: [ :each | each withAllSuperclasses ])
		select: [ :each | each superclass == UnrestEndpoint ].
	^ (rootEndpointClass flatCollect: #withAllSubclasses)
]

{ #category : #introspection }
Unrest class >> endpointMethods [
	^ self endpointMethodsOn: self
]

{ #category : #introspection }
Unrest class >> endpointMethodsOn: aClass [
	^ (aClass methods
		collect: [ :aMethod | 
			aMethod
				->
					(aMethod allLiterals
						select: [ :aLiteral | aLiteral value isClass and: [ aLiteral value inheritsFrom: UnrestEndpoint ] ]) ])
		select: [ :each | each value isNotEmpty ]
]

{ #category : #'instance creation' }
Unrest class >> withUrl: aUrl [
	^ self basicNew initializeWithUrl: aUrl
]

{ #category : #endpoints }
Unrest >> / aString [
	"Creates a new generic endpoint."
	^ (UnrestPluggableEndpoint on: self) path: (Path / aString); yourself
]

{ #category : #endpoints }
Unrest >> > endPointClass [
	"Creates a new endpoint of specified class."
	^ endPointClass on: self
]

{ #category : #http }
Unrest >> allowedHttpMethods [
	^ #(#get #post #put #patch #delete #options)
]

{ #category : #accessing }
Unrest >> baseUrl [
	^ baseUrl
]

{ #category : #http }
Unrest >> configureHttpClient: http [
	contentReader ifNotNil: [ :val | http contentReader: val ].
	contentWriter ifNotNil: [ :val | http contentWriter: val ]
]

{ #category : #accessing }
Unrest >> contentReader [
	^ contentReader
]

{ #category : #accessing }
Unrest >> contentReader: anObject [
	contentReader := anObject
]

{ #category : #accessing }
Unrest >> contentWriter [
	^ contentWriter
]

{ #category : #accessing }
Unrest >> contentWriter: anObject [
	contentWriter := anObject
]

{ #category : #http }
Unrest >> createHttpClient [
	| client |
	client := ZnClient new.
	self configureHttpClient: client.
	^ client
]

{ #category : #execution }
Unrest >> execute [
	| sender |
	sender := thisContext sender.
	(sender methodClass inheritsFrom: UnrestEndpoint) ifFalse: [ UnrestError signal: ('Cannot be executed by {1} because it is not an UnrestEndpoint!' format: { sender class greaseString}) ].
	self execute: sender
]

{ #category : #execution }
Unrest >> execute: anEndpoint [
	| http result |

	http := self createHttpClient.
	anEndpoint configureOn: http.
	self validateRequest: http request.
	result := http execute.
	self validateResponse: http response.
	^ result
]

{ #category : #initialization }
Unrest >> initializeWithUrl: aUrl [
	self initialize.
	baseUrl := aUrl asUrl
]

{ #category : #http }
Unrest >> validateMethod: aMethod [
	| method |
	method := aMethod asLowercase.
	^ (self allowedHttpMethods includes: method)
		ifTrue: [ method asSymbol ]
		ifFalse:
			[ UnrestError signal: ('Tried to perform invalid Method "{1}"' format: {aMethod}) ]
]

{ #category : #http }
Unrest >> validateRequest: aRequest [
	(aRequest method isNotNil and: [ aRequest url isNotNil ]) ifFalse: [ UnrestError signal: 'Invalid HTTP Request' ]
]

{ #category : #http }
Unrest >> validateResponse: aResponse [
	aResponse isSuccess
		ifTrue: [ ^ true ].
	UnrestError
		signal:
			('{1}: {2}'
				format:
					{aResponse statusLine code.
					aResponse statusLine reason}).
	^ false
]
