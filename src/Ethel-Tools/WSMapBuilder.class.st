Class {
	#name : #WSMapBuilder,
	#superclass : #RTInteractiveTreeBuilder,
	#category : #'Ethel-Tools'
}

{ #category : #interactions }
WSMapBuilder >> clickOnElement: e [
	(self isElementSelected: e)
		ifTrue: [ self unselectElement: e ]
		ifFalse: [ self selectElement: e ]
]

{ #category : #initialization }
WSMapBuilder >> colorForSelected: anObj [
	^ (Color colorFrom: '#4682B4') muchLighter
]

{ #category : #interactions }
WSMapBuilder >> isElementSelected: e [
	^ e attributes at: #selected ifAbsent: [ false ]
]

{ #category : #interactions }
WSMapBuilder >> selectElement: e [
	(self elements select: [ :each | self isElementSelected: each ])
		do: [ :each | self unselectElement: each ].
	e attributes at: #selected put: true.
	e attributes at: #originalColor put: e color.
	e color: (self colorForSelected: e)
]

{ #category : #interactions }
WSMapBuilder >> unselectElement: e [
	e attributes removeKey: #selected.
	e attributes
		at: #originalColor
		ifPresent: [ :val | e color: val ]
		ifAbsent: [  ].
	e attributes removeKey: #originalColor
]
