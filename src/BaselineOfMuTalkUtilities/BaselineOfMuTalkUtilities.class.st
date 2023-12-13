Class {
	#name : 'BaselineOfMuTalkUtilities',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMuTalkUtilities',
	#package : 'BaselineOfMuTalkUtilities'
}

{ #category : 'baselines' }
BaselineOfMuTalkUtilities >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'MuTalk'
			with: [ spec repository: 'github://pharo-contributions/mutalk/src' ];
			package: 'MuTalk-Utilities' with: [ spec requires: #('MuTalk') ].

		spec group: 'default' with: #( 'MuTalk-Utilities' ) ]
]
