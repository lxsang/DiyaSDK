|pkgn dest pkg fileReference fileName writer core hePackage ignoresClasses|
FFIMethodRegistry resetAll.
dest := Smalltalk arguments first.
pkgn :=  Smalltalk arguments at:2.

core := HEPackage new.
core classes: OrderedCollection new.
core traits: OrderedCollection new.
core extensionMethods: OrderedCollection new.
core packageName: pkgn.

packages := #(
	'Kernel-Chronology-Extras' 
	'Jobs' 
	'Collections-Arithmetic'
	'Ring-Deprecated-Core-Kernel'
	'Math-Operations-Extensions'
	'Collections-Atomic' 
	'Collections-DoubleLinkedList' 
	'DeprecatedFileStream' 
	'Zinc-Resource-Meta-Core' 
	'Zinc-Character-Encoding-Core' 
	'FileSystem-Core' 
	'FileSystem-Disk' 
	'FileSystem-Memory' 
	'Compression' 
	'FileSystem-Zip' 
	'Multilingual-Encodings' 
	'Multilingual-Languages' 
	'Multilingual-TextConversion' 
	'Text-Core' 
	'AST-Core' 
	'Debugging-Core' 
	'OpalCompiler-Core' 
	'Kernel-Traits' 
	'AST-Core-Traits' 
	'Collections-Abstract-Traits' 
	'Transcript-Core-Traits' 
	'TraitsV2-Compatibility' 
	'Alien-Core' 
	'System-Model' 
	'PragmaCollector'  
	'UnifiedFFI'
	'UnifiedFFI-Legacy'
	'Slot-Core' 
	'System-Localization' 
	'STON-Core'
	'Colors'
	'Graphics-Primitives'
	'Graphics-Files'
	'Diya'
).

ignoresClasses := {
	RGCommentDefinition.
	RGMethodDefinition.
	ChangeRecord.
	PluggableListMorph.
	TextLine.
	TransformMorph.
	StringMorph.
	AthensCairoSDLSurface.
	SourceFileArray.
	GlyphForm.
	ManifestGraphicsPrimitives.
	EllipseMidpointTracer.
	GrafPort
}.
"remove some unused meothods"
Form class 
		removeSelector: #serviceOpenImageInWindow;
		removeSelector: #openImageInWindow:;
		removeSelector: #serviceImageAsBackground;
		removeSelector: #setBackgroundFromImageFileNamed:;
		removeSelector: #services.
Form
	removeSelector: #setAsBackground;
	removeSelector: #scaledByDisplayScaleFactor.

packages do:[:name | |pkg trait classes extensionMethods|
	Transcript show: 'Processing package ',name;cr.
	FFIMethodRegistry resetAll.
	pkg := RPackageOrganizer default packageNamed: name asSymbol.
	traits := (pkg definedClasses select: #isTrait) do: [ :e | core traits add:(HETrait for: e) ].
	(pkg definedClasses reject: #isTrait) do: [ :e |
		(ignoresClasses includes:e) ifFalse:[
			core addClass: (HEClass for: e) ].
		].
	pkg extensionMethods do: [ :e | 
		(ignoresClasses includes:e classBinding value) ifFalse:[
			core extensionMethods add:(HEMethod for: e)
		]
	].
].

"SDL binding class"
pkg := RPackageOrganizer default packageNamed: 'OSWindow-SDL2' asSymbol.
(pkg classNamesForClassTag: 'Bindings') do:[:e|
	(ignoresClasses includes:e asClass) ifFalse:[
	core addClass:(HEClass for:e asClass) ]].

"FreeType binding class"
pkg := RPackageOrganizer default packageNamed: 'FreeType' asSymbol.
(pkg classNamesForClassTag: 'Base') do:[:e|
	(ignoresClasses includes:e asClass) ifFalse:[
	core addClass:(HEClass for:e asClass) ]].
(pkg classNamesForClassTag: 'Bindings') do:[:e|
	(ignoresClasses includes:e asClass) ifFalse:[
	core addClass:(HEClass for:e asClass) ]].

"fixing some missing classes"
core addClass: (HEClass for:OSWindowPlatformSpecificHandle);
	addClass: (HEClass for:ChunkWriteStream);
	addClass: (HEClass for:ChunkReadStream);
	addClass: (HEClass for:STCommandLineHandler);
	addClass: (HEClass for:FreeTypeFace);
	"form object support"
	addClass: (HEClass for:DisplayObject);
	addClass: (HEClass for:DisplayMedium);
	addClass: (HEClass for:Form);
	addClass: (HEClass for:ColorForm);
	addClass: (HEClass for:ColorArray);
	addClass: (HEClass for: AnimatedImageFrame)
	.

fileReference := (dest,'/',(pkgn replaceAll: Character space with: $-),'.hermes') asFileReference.
fileName := fileReference fullName.
writer := HEBinaryReaderWriter new
		stream: (File openForWriteFileNamed:fileName);
		yourself.
core writeInto: writer.

writer stream flush.
Transcript show: 'File exported to ', dest, '/', pkgn, '.hermes'; cr.