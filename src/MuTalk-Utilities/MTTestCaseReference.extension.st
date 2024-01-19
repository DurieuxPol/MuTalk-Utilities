Extension { #name : 'MTTestCaseReference' }

{ #category : '*MuTalk-Utilities' }
MTTestCaseReference >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	anObject species = self class ifFalse: [ ^ false ].
	self testCaseClass = anObject testCaseClass ifFalse: [ ^ false ].
	^ self selector = anObject selector
]

{ #category : '*MuTalk-Utilities' }
MTTestCaseReference >> selector [

	^ selector
]

{ #category : '*MuTalk-Utilities' }
MTTestCaseReference >> testCaseClass [

	^ class
]
