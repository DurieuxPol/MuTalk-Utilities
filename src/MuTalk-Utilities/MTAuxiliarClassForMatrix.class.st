Class {
	#name : 'MTAuxiliarClassForMatrix',
	#superclass : 'Object',
	#instVars : [
		'counter'
	],
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'initialization' }
MTAuxiliarClassForMatrix >> initialize [

	super initialize.
	counter := 0
]

{ #category : 'accessing' }
MTAuxiliarClassForMatrix >> minus: aNumber [

	counter := counter - aNumber.
	^ self reset
]

{ #category : 'accessing' }
MTAuxiliarClassForMatrix >> plus: aNumber [

	counter := counter + aNumber.
	^ self reset
]

{ #category : 'resetting' }
MTAuxiliarClassForMatrix >> reset [

	| count |
	count := counter.
	counter := 0.
	^ count
]
