Class {
	#name : 'MutantOperatorAnalysis',
	#superclass : 'Object',
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'computing' }
MutantOperatorAnalysis >> completeAnalysisFor: aCollectionOfPackages [

	| allOperatorsDictionary |
	allOperatorsDictionary := Dictionary new.

	aCollectionOfPackages do: [ :name |
		| operatorsDictionary |
		operatorsDictionary := self getMutantOperatorsDictionaryFor: name.

		operatorsDictionary := operatorsDictionary asDictionary
			                       addAllWithoutOverwrite:
				                       (self findNullOperatorsFor:
						                        operatorsDictionary);
			                       yourself.
		allOperatorsDictionary addAllWithoutOverwrite: operatorsDictionary ].

	^ self findWeakOperatorsFor: allOperatorsDictionary
]

{ #category : 'computing' }
MutantOperatorAnalysis >> findNullOperatorsFor: aDictionary [

	| operatorsWithoutMutants |
	operatorsWithoutMutants := (MutantOperator contentsAll collect:
		                            #species) reject: [ :ope |
		                           aDictionary keys includes: ope ].

	^ OrderedDictionary new
		  addAll: (operatorsWithoutMutants collect: [ :each | each -> 0 ]);
		  yourself
]

{ #category : 'computing' }
MutantOperatorAnalysis >> findWeakOperatorsFor: aDictionary [

	^ aDictionary select: [ :value | value <= self minimalMutantsNumber ]
]

{ #category : 'computing' }
MutantOperatorAnalysis >> getMutantOperatorsDictionaryFor: aName [

	| analysis dic classesToMutate testCases |
	classesToMutate := aName asPackage definedClasses.
	testCases := (aName , '-Tests') asPackage definedClasses select:
		             #isTestCase.

	analysis := MutationTestingAnalysis
		            testCasesFrom: testCases
		            mutating: classesToMutate
		            using: MutantOperator contentsAll
		            with: AllTestsMethodsRunningTestSelectionStrategy new
		            with: AllMutantSelectionStrategy new.

	analysis generateMutations.

	^ dic := (analysis mutations groupedBy: [ :e | e operator species ])
		         collect: [ :coll | coll size ]
]

{ #category : 'accessing' }
MutantOperatorAnalysis >> minimalMutantsNumber [

	^ 5
]
