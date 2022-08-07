|change|
change := false.
HEBinaryReaderWriter ifNil:[
	[
		Metacello new
		repository: 'github://lxsang/hermes';
		baseline:'Hermes';
		load
	] on: Warning do: #resume.
	change := true.
].

DiyaBoot ifNil:[
	[
		Metacello new
		repository: 'github://lxsang/Diya-API';
		baseline:'Diya';
		load
	] on: Warning do: #resume.
	change := true.
].

change ifTrue:[
	FTSizeRec rebuildFieldAccessors.
	Smalltalk snapshot: true andQuit: true.
].