Class {
	#name : #WeakOperatorsFinder,
	#superclass : #Object,
	#category : #'MuTalk-Utilities'
}

{ #category : #'as yet unclassified' }
WeakOperatorsFinder >> weakOperatorsFor: classesToMutate tests: testCases [

	| analysis dic operators operatorsWithoutMutants |
	analysis := MutationTestingAnalysis
		            testCasesFrom: testCases
		            mutating: classesToMutate
		            using: MutantOperator contents
		            with: AllTestsMethodsRunningTestSelectionStrategy new
		            with: AllMutantSelectionStrategy new.

	analysis run.

	dic := analysis mutations groupedBy: [ :e | e operator ].
	operators := (dic collect: [ :coll | coll size ]) select: [ :value |
		                value <= 10 ].
	operatorsWithoutMutants := MutantOperator contents reject: [ :ope |
		                           (dic keys collect: [ :e | e species ])
			                           includes: ope species ].
	operatorsWithoutMutants do: [ :op | operators add: op -> 0 ].
	^ operators
]
