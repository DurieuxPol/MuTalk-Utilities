Class {
	#name : 'MTAuxiliarClassForMatrixTest',
	#superclass : 'TestCase',
	#instVars : [
		'obj'
	],
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'running' }
MTAuxiliarClassForMatrixTest >> setUp [

	super setUp.
	obj := MTAuxiliarClassForMatrix new
]

{ #category : 'running' }
MTAuxiliarClassForMatrixTest >> testDecrement [

	self assert: obj decrement equals: -1
]

{ #category : 'running' }
MTAuxiliarClassForMatrixTest >> testIncrement [

	self assert: obj increment equals: 1
]

{ #category : 'running' }
MTAuxiliarClassForMatrixTest >> testMinus [

	self assert: (obj minus: 10) equals: -10
]

{ #category : 'running' }
MTAuxiliarClassForMatrixTest >> testPlus [

	self assert: (obj plus: 10) equals: 10
]
