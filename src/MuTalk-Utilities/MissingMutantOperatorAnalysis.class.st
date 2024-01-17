Class {
	#name : 'MissingMutantOperatorAnalysis',
	#superclass : 'Object',
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'as yet unclassified' }
MissingMutantOperatorAnalysis >> findMethodsWithoutMutationFor: aCollectionOfPackages [

	| allMethods allMutatedMethods |
	allMethods := self getAllMethodsFrom: aCollectionOfPackages.
	allMutatedMethods := OrderedCollection new.
	aCollectionOfPackages do: [ :name |
		allMutatedMethods addAll: (self getMutatedMethodsFrom: name) ].

	^ allMethods reject: [ :method | allMutatedMethods includes: method ]
]

{ #category : 'as yet unclassified' }
MissingMutantOperatorAnalysis >> getAllMethodsFrom: aCollectionOfPackages [

	| allMethods |
	allMethods := OrderedCollection new.
	aCollectionOfPackages do: [ :name | allMethods addAll: name asPackage methods ].
	^ allMethods
]

{ #category : 'as yet unclassified' }
MissingMutantOperatorAnalysis >> getMutatedMethodsFrom: aName [

	| classesToMutate testCases analysis |
	classesToMutate := aName asPackage definedClasses.
	testCases := (aName , '-Tests') asPackage definedClasses select: #isTestCase.

	analysis := MutationTestingAnalysis
		            testCasesFrom: testCases
		            mutating: classesToMutate
		            using: MutantOperator contentsAll.
	^ (analysis generateMutations groupedBy: #originalMethod) keys
]
