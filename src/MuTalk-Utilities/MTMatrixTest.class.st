Class {
	#name : 'MTMatrixTest',
	#superclass : 'TestCase',
	#instVars : [
		'matrix',
		'trivialMutant',
		'equivalentMutants'
	],
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'running' }
MTMatrixTest >> setUp [

	| mutations |
	super setUp.
	matrix := MTMatrix forAClass: MTAuxiliarClassForMatrix.
	matrix build.
	mutations := matrix analysis mutations.
	trivialMutant := Array with:
		                 (matrix analysis mutations detect: [ :mut |
			                  mut originalMethod
			                  = (MTAuxiliarClassForMatrix >> #reset) ]).
	equivalentMutants := Set
		                     with: (mutations select: [ :mut |
				                      mut originalMethod
				                      = (MTAuxiliarClassForMatrix >> #minus:) ])
				                     asSet
		                     with: (mutations select: [ :mut |
				                      mut originalMethod
				                      = (MTAuxiliarClassForMatrix >> #plus:) ])
				                     asSet
]

{ #category : 'tests' }
MTMatrixTest >> testEquivalentMutants [

	self assert: matrix equivalentMutants equals: equivalentMutants
]

{ #category : 'tests' }
MTMatrixTest >> testTrivialMutants [

	self assert: matrix trivialMutants equals: trivialMutant
]
