Class {
	#name : #WSBase64ContentBuilder,
	#superclass : #WSContentBuilder,
	#category : #'Ethel-Builders'
}

{ #category : #initialization }
WSBase64ContentBuilder >> initialize [
	super initialize.
	reader := [ :aString | aString base64Decoded ].
	writer := [ :bytes | bytes base64Encoded ]
]
