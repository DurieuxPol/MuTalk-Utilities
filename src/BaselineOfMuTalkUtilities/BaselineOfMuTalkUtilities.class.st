Class {
	#name : #BaselineOfMuTalkUtilities,
	#superclass : #BaselineOf,
	#category : #BaselineOfMuTalkUtilities
}

{ #category : #baselines }
BaselineOfMuTalkUtilities >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'MuTalk'
			with: [ spec repository: 'github://pharo-contributions/mutalk' ];
			package: 'MuTalk-Utilities'.

		spec group: 'default' with: #( 'MuTalk-Utilities' ) ]
]
