Class {
	#name : 'MutantOperatorAnalysis',
	#superclass : 'Object',
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'computing' }
MutantOperatorAnalysis >> findOperatorsWithoutMutantsFor: classesToMutate withTests: testCases [

	| operatorsDictionary operatorsWithoutMutants |
	operatorsDictionary := self
		                       getMutantOperatorsDictionaryFor:
		                       classesToMutate
		                       withTests: testCases.

	^ operatorsWithoutMutants := MutantOperator contentsAll reject: [
		                             :ope |
		                             (operatorsDictionary keys collect: [ :e |
			                              e species ]) includes: ope species ]
]

{ #category : 'computing' }
MutantOperatorAnalysis >> findWeakOperatorsFor: classesToMutate withTests: testCases [

	| operatorsDictionary weakOperators |
	operatorsDictionary := self
		                       getMutantOperatorsDictionaryFor:
		                       classesToMutate
		                       withTests: testCases.

	^ weakOperators := (operatorsDictionary collect: [ :coll | coll size ])
		                   select: [ :value |
		                   value <= self minimalMutantsNumber ]
]

{ #category : 'computing' }
MutantOperatorAnalysis >> getMutantOperatorsDictionaryFor: classesToMutate withTests: testCases [

	| analysis dic |
	analysis := MutationTestingAnalysis
		            testCasesFrom: testCases
		            mutating: classesToMutate
		            using: MutantOperator contentsAll
		            with: AllTestsMethodsRunningTestSelectionStrategy new
		            with: AllMutantSelectionStrategy new.

	analysis generateMutations.

	^ dic := analysis mutations groupedBy: [ :e | e operator ]
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
