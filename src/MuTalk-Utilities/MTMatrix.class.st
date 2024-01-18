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
MTMatrix >> getTrivialMutants [

	^ self keys select: [ :mutant |
		  (self at: mutant) fold: [ :bool1 :bool2 | bool1 and: bool2 ] ]
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
