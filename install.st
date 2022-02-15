|change|
change := false.
HEBinaryReaderWriter ifNil:[
	[
		Metacello new
		repository: 'github://tesonep/hermes';
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
	Smalltalk snapshot: true andQuit: true.
].