Extension { #name : #PathTest }

{ #category : #'*Ethel-Tests' }
PathTest >> testMatches [
	| shortSimple longSimple wildStart wildMiddle wildEnd recurseStart recurseMiddle recurseEnd noMatchStart noMatchMiddle noMatchEnd |

	shortSimple := Path / #foo.
	longSimple := Path / #foo / #bar / #baz.
	wildStart := Path / #* / #bar.
	wildMiddle := Path / #foo / #* / #baz.
	wildEnd := Path / #foo / #bar / #*.
	recurseStart := Path / #**.
	recurseMiddle := Path / #foo / #** / #baz.
	recurseEnd := Path / #foo / #**.

	noMatchStart := Path / #moMatch.
	noMatchMiddle := Path / #foo / #noMatch.
	noMatchEnd := Path / #foo / #bar / #noMatch.

	{shortSimple.
	longSimple.
	wildStart.
	wildMiddle.
	wildEnd.
	recurseStart.
	recurseMiddle.
	recurseEnd}
		do: [ :aPath | 
			(aPath matches: aPath) should be: true.
			(aPath matches: aPath pathString) should be: true ].

	(shortSimple matches: Path / #*) should be: true.
	(longSimple matches: Path / #*) should be: false.
	(longSimple matches: '/foo/*') should be: false.
	(longSimple matches: '/foo/bar/*') should be: true.
	(longSimple matches: '/*/bar/baz') should be: true.
	(longSimple matches: '/*/*/baz') should be: true.
	(longSimple matches: '/*/*/*') should be: true.
	(longSimple matches: '/*/baz') should be: false.

	{recurseStart.
	recurseMiddle.
	recurseEnd}
		do: [ :aPath | (longSimple matches: aPath) should be: true ].

	{noMatchStart.
	noMatchMiddle.
	noMatchEnd}
		do: [ :aPath | (longSimple matches: aPath) should be: false ]
]
