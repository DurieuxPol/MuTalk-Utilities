Class {
	#name : 'MTMatrix',
	#superclass : 'Dictionary',
	#instVars : [
		'analysisResult',
		'mutations',
		'testCases',
		'analysis',
		'classesToMutate',
		'testClasses'
	],
	#category : 'MuTalk-Utilities',
	#package : 'MuTalk-Utilities'
}

{ #category : 'instance creation' }
MTMatrix class >> forAClass: aClass [

	^ self new
		  classesToMutate: (Set with: aClass);
		  testClasses: (Set with:
					   (aClass name , 'Test' asClassInEnvironment:
							    self class environment))
]

{ #category : 'instance creation' }
MTMatrix class >> forAPackage: aPackage [

	^ self new
		  classesToMutate: aPackage asPackage definedClasses;
		  testClasses:
			  ((aPackage , '-Tests') asPackage definedClasses select:
					   #isTestCase)
]

{ #category : 'instance creation' }
MTMatrix class >> forAPackage: aPackage andTestPackage: aTestPackage [

	^ self new
		  classesToMutate: aPackage asPackage definedClasses;
		  testClasses:
			  (aTestPackage asPackage definedClasses select: #isTestCase)
]

{ #category : 'accessing' }
MTMatrix >> analysis [

	^ analysis
]

{ #category : 'as yet unclassified' }
MTMatrix >> booleanCollection1: collection1 equalsBooleanCollection2: collection2 [

	collection1 size = collection2 size ifFalse: [ ^ false ].
	1 to: collection1 size do: [ :i |
		((collection1 at: i) eqv: (collection2 at: i)) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'as yet unclassified' }
MTMatrix >> build [

	self runAnalysis.
	mutations do: [ :mut |
		self
			at: mut
			put:
			(testCases collect: [ :test |
				 (self failuresFor: mut) includes: test ]) ]
]

{ #category : 'accessing' }
MTMatrix >> classesToMutate: aClass [

	classesToMutate := aClass
]

{ #category : 'as yet unclassified' }
MTMatrix >> evaluationResultFor: aMutant [

	^ (analysis mutantResults detect: [ :evaluationResult |
		   evaluationResult mutant = aMutant ]) result
]

{ #category : 'as yet unclassified' }
MTMatrix >> failuresFor: aMutant [

	^ (self evaluationResultFor: aMutant) defects asOrderedCollection collect: [ :each |
		  MTTestCaseReference for: each selector in: each class ]
]

{ #category : 'as yet unclassified' }
MTMatrix >> generateMatrix [

	| matrix |
	self runAnalysis.
	matrix  := RSDSM new.
	matrix objectsX: mutations .
	matrix objectsY: testCases .
	matrix dependency: [ :mutation | (self at: mutation) ].
	matrix open
]

{ #category : 'as yet unclassified' }
MTMatrix >> getEquivalentMutants [

	| equivalentMutants |
	equivalentMutants := Set new.

	mutations do: [ :mutant1 |
		| eqMutants |
		eqMutants := Set with: mutant1.
		mutations do: [ :mutant2 |
			(self mutant1: mutant1 equivalentToMutant2: mutant2) ifTrue: [
				eqMutants add: mutant2 ] ].
		eqMutants size > 1 ifTrue: [ equivalentMutants add: eqMutants ] ].
	
	^ equivalentMutants
]

{ #category : 'as yet unclassified' }
MTMatrix >> getTrivialMutants [

	^ self keys select: [ :mutant |
		  (self at: mutant) fold: [ :bool1 :bool2 | bool1 and: bool2 ] ]
]

{ #category : 'as yet unclassified' }
MTMatrix >> mutant1: mutant1 equivalentToMutant2: mutant2 [

	^ self
		  booleanCollection1: (self at: mutant1)
		  equalsBooleanCollection2: (self at: mutant2)
]

{ #category : 'accessing' }
MTMatrix >> mutations: anObject [

	mutations := anObject
]

{ #category : 'running' }
MTMatrix >> runAnalysis [

	analysis := MTAnalysis new
		            classesToMutate: classesToMutate;
		            testClasses: testClasses;
		            doNotStopOnErrorOrFail.
	analysis run.
	testCases := analysis testCases.
	mutations := analysis mutations
]

{ #category : 'accessing' }
MTMatrix >> testClasses: aTestClass [

	testClasses := aTestClass
]
