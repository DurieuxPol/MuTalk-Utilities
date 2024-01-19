Class {
	#name : 'MTMatrixTest',
	#superclass : 'TestCase',
	#instVars : [
		'matrix'
	],
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'running' }
MTMatrixTest >> setUp [

	super setUp.
	matrix := MTMatrix forAClass: MTAuxiliarClassForMatrix.
	matrix build
]

{ #category : 'tests' }
MTMatrixTest >> testTrivialMutants [

	| mutant |
	self assert: matrix getTrivialMutants size equals: 1.
	mutant := matrix getTrivialMutants at: 1.
	self
		assert: (matrix getTrivialMutants at: 1)
		equals: (MTMethodMutation
				 for: MTAuxiliarClassForMatrix >> #reset
				 using: MTRemoveCaretOperator new
				 nodeNumber: 1
				 ofClass: MTAuxiliarClassForMatrix)
]
