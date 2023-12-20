Class {
	#name : 'MutantOperatorAnalysis',
	#superclass : 'Object',
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'computing' }
MutantOperatorAnalysis >> allOperatorsFor: aCollectionOfPackages [

	| allOperatorsDictionary |
	allOperatorsDictionary := Dictionary new.

	aCollectionOfPackages do: [ :name |
		| operatorsDictionary |
		operatorsDictionary := self getMutantOperatorsDictionaryFor: name.

		operatorsDictionary := operatorsDictionary asDictionary
			                       addAllWithoutOverwrite:
				                       (self findOperatorsWithoutMutantsFor:
						                        operatorsDictionary);
			                       yourself.
		allOperatorsDictionary addAllWithoutOverwrite: operatorsDictionary ].

	^ allOperatorsDictionary
]

{ #category : 'computing' }
MutantOperatorAnalysis >> findOperatorsWithoutMutantsFor: aDictionary [

	| operatorsWithoutMutants |
	operatorsWithoutMutants := (MutantOperator contentsAll collect:
		                            #species) reject: [ :ope |
		                           aDictionary keys includes: ope ].

	^ OrderedDictionary new
		  addAll: (operatorsWithoutMutants collect: [ :each | each -> 0 ]);
		  yourself
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

{ #category : 'computing' }
MutantOperatorAnalysis >> operatorsProducingOver: aNumber mutantsFor: aCollectionOfPackages [

	^ self
		  operatorsSelectedWith: [ :value | value >= aNumber ]
		  For: aCollectionOfPackages
]

{ #category : 'computing' }
MutantOperatorAnalysis >> operatorsProducingUnder: aNumber mutantsFor: aCollectionOfPackages [

	^ self
		  operatorsSelectedWith: [ :value | value <= aNumber ]
		  For: aCollectionOfPackages
]

{ #category : 'computing' }
MutantOperatorAnalysis >> operatorsSelectedWith: aBlock For: aCollectionOfPackages [

	^ (self allOperatorsFor: aCollectionOfPackages) select: aBlock
]
