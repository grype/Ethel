Class {
	#name : #GHApiConfiguration,
	#superclass : #Object,
	#instVars : [
		'url',
		'authToken'
	],
	#classVars : [
		'ApiOAuthToken'
	],
	#category : #'Ethel-Examples-Github-Common'
}

{ #category : #defaults }
GHApiConfiguration class >> defaultAuthToken [
	^ self ghApiOAuthToken
]

{ #category : #defaults }
GHApiConfiguration class >> ghApiOAuthToken [
	^ ApiOAuthToken ifNil: [ ApiOAuthToken := 'Github API OAuth Token' ]
]

{ #category : #defaults }
GHApiConfiguration class >> ghApiOAuthToken: aString [
	ApiOAuthToken := aString
]

{ #category : #'instance creation' }
GHApiConfiguration class >> graphql [
	^ self new
		url: 'https://api.github.com/graphql' asUrl;
		authToken: self defaultAuthToken;
		yourself
]

{ #category : #defaults }
GHApiConfiguration class >> oauthSettingsOn: aBuilder [
	<systemsettings>
	
	(aBuilder group: #Ethel)
		label: 'Ethel';
		parent: #tools;
		description: 'Settings related to Ethel'.
		
	(aBuilder setting: #ghApiOAuthToken)
		label: 'GitHub API OAuth Token' translated;
		parent: #Ethel;
		target: self;
		description: 'API OAuth token to be used by GHApiConfiguration' translated
]

{ #category : #'instance creation' }
GHApiConfiguration class >> rest [
	^ self new
		url: 'https://api.github.com/' asUrl;
		authToken: self defaultAuthToken;
		yourself
]

{ #category : #accessing }
GHApiConfiguration >> authToken [
	^ authToken
]

{ #category : #accessing }
GHApiConfiguration >> authToken: anObject [
	authToken := anObject
]

{ #category : #accessing }
GHApiConfiguration >> url [
	^ url
]

{ #category : #accessing }
GHApiConfiguration >> url: anObject [
	url := anObject
]
