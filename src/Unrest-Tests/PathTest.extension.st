Extension { #name : #PathTest }

{ #category : #'*Unrest-Tests' }
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
			(aPath matches: aPath) should beTrue.
			(aPath matches: aPath pathString) should beTrue ].

	(shortSimple matches: Path / #*) should beTrue.
	(longSimple matches: Path / #*) should beFalse.
	(longSimple matches: '/foo/*') should beFalse.
	(longSimple matches: '/foo/bar/*') should beTrue.
	(longSimple matches: '/*/bar/baz') should beTrue.
	(longSimple matches: '/*/*/baz') should beTrue.
	(longSimple matches: '/*/*/*') should beTrue.
	(longSimple matches: '/*/baz') should beFalse.

	{recurseStart.
	recurseMiddle.
	recurseEnd}
		do: [ :aPath | (longSimple matches: aPath) should beTrue ].

	{noMatchStart.
	noMatchMiddle.
	noMatchEnd}
		do: [ :aPath | (longSimple matches: aPath) should beFalse ]
]
