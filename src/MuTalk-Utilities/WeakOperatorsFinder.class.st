Class {
	#name : #WeakOperatorsFinder,
	#superclass : #Object,
	#instVars : [
		'classesToMutate',
		'testCases'
	],
	#category : #'MuTalk-Utilities'
}

{ #category : #'instance creation' }
WeakOperatorsFinder class >> for: classesToMutate tests: testCases [

	^ self new
		  classesToMutate: classesToMutate;
		  testCases: testCases
]

{ #category : #accessing }
WeakOperatorsFinder >> classesToMutate [

	^ classesToMutate
]

{ #category : #accessing }
WeakOperatorsFinder >> classesToMutate: classes [

	classesToMutate := classes
]

{ #category : #computing }
WeakOperatorsFinder >> find [

	| analysis dic operators operatorsWithoutMutants |
	analysis := MutationTestingAnalysis
		            testCasesFrom: testCases
		            mutating: classesToMutate
		            using: MutantOperator contentsAll
		            with: AllTestsMethodsRunningTestSelectionStrategy new
		            with: AllMutantSelectionStrategy new.

	analysis generateMutations.

	dic := analysis mutations groupedBy: [ :e | e operator ].

	operators := (dic collect: [ :coll | coll size ]) select: [ :value |
		             value <= self minimalMutantsNumber ].

	operatorsWithoutMutants := MutantOperator contentsAll reject: [ :ope |
		                           (dic keys collect: [ :e | e species ])
			                           includes: ope species ].
	operatorsWithoutMutants do: [ :op | operators add: op -> 0 ].
	^ operators
]

{ #category : #accessing }
WeakOperatorsFinder >> minimalMutantsNumber [

	^ 10
]

{ #category : #accessing }
WeakOperatorsFinder >> testCases [

	^ testCases
]

{ #category : #accessing }
WeakOperatorsFinder >> testCases: tests [

	testCases := tests
]
