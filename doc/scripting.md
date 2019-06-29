# Scripting

`WSClient` provides enough functionality to be used as-is, without the need to subclass it. Together with `WSPluggableEndpoint` it is possible to script the client without having to create concrete endpoints.

Let’s take GitHub’s Gist API for example. First create a client

```smalltalk
client := WSClient jsonWithUrl: 'https://api.github.com/'.
```

The gists API lives behind */gists* and some of the endpoints require an authentication token. Let’s configure the client with our API auth token, using `#httpConfiguration:` hook:

```smalltalk
client httpConfiguration: [ :http |
    http headerAt: 'Authorization' put: 'token <MyAuthToken>'
].
```

Now, let’s try to hit */gists/public*.

```smalltalk
(client / #gists / #public) get.
```

We should be getting some dictionary data back. Let’s see what’s going on here:

`client / #gists` returns an instance of `WSPluggableEndpoint`, configured with the */gists* path. Sending it `/ #public` produces yet another `WSPluggableEndpoint`, this time configured with the */gists/public* path. Finally, we invoke `#get` on the resulting endpoint. `WSPluggableEndpoint` defines all of the common http methods as **execution methods**. So, calling `#get` ends up configuring the request with the *GET* method, and then executing the request.

Posts are generally more involving, so let’s take a look at what it would take to create a gist with instructions to load Ethel:

```smalltalk
loadScript := 'Metacello new
    baseline: ''Ethel''; 
    repository: ''github://grype/Ethel''; 
    load'.

files := { ‘example.st’ -> ({ #content -> loadScript } asDictionary) } asDictionary.
     
(client / #gists) 
    post: [ :http | 
        http contents: {
        #description -> 'Loading Ethel’.
        #public -> true.
        #files -> files } asDictionary ].
```

The first couple of statements simply setup the “file” portion of the payload. The last statement creates a `WSPluggableEndpoint` instance via `client / #gists`, and executes POST after configuring the request by setting its body to JSON representation of the payload.

Lastly, `WSPluggableEndpoint` supports enumeration via `#enumeration`. Let’s see how this works:

```smalltalk
endpoint enumeration: [ :endpoint :limit :cursor |
    | result |
	"Return result of #get:, and update cursor"
	result := endpoint get: [ :http | 
    	http 
			queryAt: #page put: (cursor at: #page ifAbsentPut: 1);
			queryAt: #page_size put: (cursor at: #page_size ifAbsentPut: 100) ].
	cursor at: #page put: (cursor at: #page) + 1.
	cursor hasMore: result size = (cursor at: #page_size).
	result ].
```

The enumeration block gets passed three arguments: an endpoint, a limit - integer indicating the maximum number of results needed, and a cursor. For the latter, an instance of `WSPluggableCursor` is used, which function similar to a dictionary for capturing arbitrary values - be it page & page size, or offset & limit, or what have you.

The enumeration block configures the endpoint to include appropriate parameters, and updates cursor data, before returning the response data. Between each iteration, the cursor is asked whether it `#hasMore` data to fetch. If the cursor says yes - the block is evaluated again. So be sure to set the pluggable cursor's `#hasMore` to false when done.

Interacting with enumerating endpoints is very similar to interacting with collections in Smalltalk. The only thing to note here is that exhaustive methods, like `#select:`, **also** take an optional max value...

```smalltalk
"exhaustive fetch"
endpoint collect: #yourself.

"Select the first 10 results and cease enumeration"
endpoint select: [:each | … ] max: 10.

"Detect a value. Enumeration ceases once a match is found, and the match is returned."
endpoint detect: [:each | … ] ifFound: [ :gist | … ].
```

That is all, for now...
