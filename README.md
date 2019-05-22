# Ethel

Ethel is a lightweight framework for composing web service clients in Pharo Smalltalk.

## Motivations
* Reduce boilerplate code
* Reduce number of tests one has to write when implementing an API
* Allow scripting
* Provide concise and easy to maintain architecture and that encourages encapsulation and composition
* Provide clear overview of the API coverage and of the implementation itself
* Encourage composition of clients that conceal much of the network-based nature behind a façade of plain old objects. For example - providing a collection-like API to paginating endpoints. 

## Installation
```smalltalk
Metacello new
  baseline: 'Ethel';
  repository: 'github://grype/unrest:ethel';
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
	at: 'load-ethel.st' put: { #content -> 'Metacello new baseline: ''Ethel''; repository: ''github://grype/unrest:ethel''; load ' } asDictionary;
	yourself.
	
(client / #gists) 
	headerAt: 'Authorization' put: 'token <YourAuthToken>';
	data: { #description -> 'Loading Ethel'. #public -> true. #files -> files } asDictionary;
	post.
```

Above are some of the examples of scripting with Ethel - namely, instantiating WSClient and deriving pluggable endpoints via #/ message. This approach is fine for quick and dirty tasks, but as you begin to cover more of the API - subclassing WSClient and implementing concrete endpoints becomes increasingly advantageous, resulting in an inteface like:

```smalltalk
client := GHRestClient default.
client gists mine.
client gists public flatCollect: #files max: 10.
client gists 
  creataeWithDescription: 'GHRestClient' 
  isPublic: true 
  files: (GHRestClient methods collect: [ :each | (each selector asString , '.st') -> each asString ]) asDictionary.
```

Concrete examples of the above can be found in `Ethel-Examples` package.

## Etymology
Ethel is named in tribute to the timeless "Ethel The Aardvark Goes Quantity Surveying". That is all...
