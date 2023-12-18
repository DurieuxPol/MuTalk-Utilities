Class {
	#name : 'MutantOperatorAnalysis',
	#superclass : 'Object',
	#instVars : [
		'classesToMutate',
		'testCases'
	],
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'instance creation' }
MutantOperatorAnalysis class >> for: classesToMutate tests: testCases [

	^ self new
		  classesToMutate: classesToMutate;
		  testCases: testCases
]

{ #category : 'accessing' }
MutantOperatorAnalysis >> classesToMutate [

	^ classesToMutate
]

{ #category : 'accessing' }
MutantOperatorAnalysis >> classesToMutate: classes [

	classesToMutate := classes
]

{ #category : 'computing' }
MutantOperatorAnalysis >> findWeakOperators [

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

{ #category : 'accessing' }
MutantOperatorAnalysis >> minimalMutantsNumber [

	^ 5
]

{ #category : 'enumerating' }
MutantOperatorAnalysis >> operatorIntersectionBetween: collection1 and: collection2 [

	^ (collection1 keys collect: #species) intersection:
		  (collection2 keys collect: #species)
]

{ #category : 'enumerating' }
MutantOperatorAnalysis >> operatorIntersectionFor: aCollection [

	| operatorCollection |
	operatorCollection := aCollection collect: [ :each |
		                      each keys collect: #species ].
	^ operatorCollection fold: [ :collection1 :collection2 |
		  collection1 intersection: collection2 ]
]

{ #category : 'accessing' }
MutantOperatorAnalysis >> testCases [

	^ testCases
]

{ #category : 'accessing' }
MutantOperatorAnalysis >> testCases: tests [

	testCases := tests
]
