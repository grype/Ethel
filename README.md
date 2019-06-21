Ethel is a lightweight framework for composing web service clients in Pharo Smalltalk.

## Motivations
* Reduce boilerplate code
* Reduce number of tests one has to write when implementing an API
* Allow scripting
* Provide concise and easy to maintain architecture - one that strongly encourages encapsulation and composition
* Provide clear overview of the API coverage and of the implementation itself
* Encourage composition of clients that conceal much of their network-based nature behind a façade of plain old objects and familiar collection-like APIs

## Installation
```smalltalk
Metacello new
  baseline: 'Ethel';
  repository: 'github://grype/Ethel';
  load.
```

## Show and Tell
There are two basic parts to the framework - a client (`WSClient`) and a collection of endpoints (instances of objects that use `TWSEndpoint` trait). `WSClient` and `WSPluggableEndpoint` provide sufficient functionality for scripting purposes. Let’s take GitHub’s Gists API as an example:

```smalltalk
client := WSClient jsonWithUrl: 'https://api.github.com/'.

"Fetch first page of public gists, this is an equivalent of making a GET request to /gists/public"
(client / #gists / #public) get.

"Create a gist"
files := Dictionary new
	at: 'example.st' put: { #content -> 'Metacello new baseline: ''Ethel''; repository: ''github://grype/unrest:ethel''; load ' } asDictionary;
	yourself.
	
(client / #gists) 
	headerAt: 'Authorization' put: 'token <YourAuthToken>';
	data: { #description -> 'Loading Ethel'. #public -> true. #files -> files } asDictionary;
	post.
```

Above are some of the examples of scripting with Ethel - namely, instantiating WSClient and deriving pluggable endpoints via #/ message. This approach is fine for quick and dirty tasks, but as you begin to cover more of the API - subclassing WSClient and implementing concrete endpoints becomes increasingly advantageous, resulting in an interface like:

```smalltalk
client := GHRestClient default.
client gists mine.
client gists public flatCollect: [:each | each at: #files] max: 10.
client gists 
  createWithDescription: 'GHRestClient' 
  isPublic: true 
  files: (GHRestClient methods collect: [ :each | (each selector asString , '.st') -> each asString ]) asDictionary.
```

Concrete examples of the above can be found in `Ethel-Examples` package.

## Etymology
Ethel is named after Monty Python's Ethel The Aardvark. That is all...
