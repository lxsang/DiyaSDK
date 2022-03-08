#! /bin/bash
set -e
[ -z "$1" ] && echo "Please specify 32 or 64 bits architectuure" && exit 1
echo "[Compiler] Adding more Kernel packages"
ARCH="$1"
W=$(dirname `realpath $0`)
BASE_DIR="$W/$ARCH"
rm "$BASE_DIR/tmp" -rf
mkdir -p "$BASE_DIR/tmp/resources/fonts"
cp $BASE_DIR/bootstrap/bootstrap7.0.image $BASE_DIR/tmp/chaos.image
cp $BASE_DIR/bootstrap/resources/fonts/* $BASE_DIR/tmp/resources/fonts
VM=$BASE_DIR/imgbuilder/pharo
IMG=$BASE_DIR/tmp/chaos.image
SRC_IMG=$BASE_DIR/imgbuilder/Pharo.image
#$VM $SRC_IMG $W/install.st --save --quit
cat << EOF > /tmp/export-packages.txt
System-Object Events
System-Sound
Hermes-Extensions
Kernel-Chronology-Extras
Kernel
Jobs
Collections-Abstract-Traits
Collections-Sequenceable
Collections-Arithmetic
Collections-Atomic
Collections-DoubleLinkedList
Zinc-Resource-Meta-Core
Zinc-Character-Encoding-Core
FileSystem-Core
FileSystem-Disk
FileSystem-Memory
Compression
UnifiedFFI
UnifiedFFI-Legacy
Alien-Core
PragmaCollector
System-Model
AST-Core
Debugging-Core
OpalCompiler-Core
FileSystem-Zip
Multilingual-Encodings
Multilingual-Languages
Multilingual-TextConversion
Multilingual-OtherLanguages
Multilingual-TextConverterOtherLanguages
Text-Scanning
Text-Core
Fonts-Abstract
Balloon
Graphics-Primitives
Graphics-Transformations
Graphics-Canvas
Graphics-Display Objects
Graphics-Files
Graphics-Fonts
Graphics-Shapes
Fonts-Infrastructure
TraitsV2
EmbeddedFreeType
FreeType
DeprecatedFileStream
System-FileRegistry
System-Clipboard
OSWindow-Core
OSWindow-SDL2
Slot-Core
System-Localization
StartupPreferences
Keymapping-Core
Keymapping-KeyCombinations
Keymapping-Pragmas
STON-Core
System-OSEnvironments
System-VMEvents
Network-Kernel
Math-Operations-Extensions
Kernel-Traits
AST-Core-Traits
Collections-Abstract-Traits
Transcript-Core-Traits
TraitsV2-Compatibility
CodeImportCommandLineHandlers
OSWindow-VM
Morphic-Core
System-Caching
MenuRegistration
Morphic-Base
Polymorph-Widgets
Text-Edition
Morphic-Widgets-Basic
Morphic-Widgets-ColorPicker
Morphic-Widgets-Extra
Morphic-Widgets-FastTable
Morphic-Widgets-List
Morphic-Widgets-Menubar
Morphic-Widgets-Pluggable
Morphic-Widgets-PolyTabs
Morphic-Widgets-Scrolling
Morphic-Widgets-Tabs
Morphic-Widgets-Taskbar
Morphic-Widgets-TickList
Morphic-Widgets-Tree
Morphic-Widgets-Windows
Regex-Core
System-History
Rubric
Text-Edition
Text-Diff
Images-Animated
Transcript-Core
Shout
Fonts-Chooser
Tool-FileList
EOF
echo "exporting packages..."
$VM $SRC_IMG $W/init.st --save --quit
while read pkg; do
    echo "exporting .....$pkg"
    $VM $SRC_IMG $W/export.st "$BASE_DIR/tmp" "$pkg" --quit
done < /tmp/export-packages.txt

#exit 1
echo "Creating image...."

$VM $IMG

cat << EOF > /tmp/packages.txt
../bootstrap/Hermes-Extensions.hermes
Kernel-Chronology-Extras.hermes
Jobs.hermes
Collections-Arithmetic.hermes
Collections-Atomic.hermes
Collections-DoubleLinkedList.hermes
DeprecatedFileStream.hermes --no-fail-on-undeclared
Zinc-Resource-Meta-Core.hermes
Zinc-Character-Encoding-Core.hermes --no-fail-on-undeclared --on-duplication=ignore
FileSystem-Core.hermes --no-fail-on-undeclared 
FileSystem-Disk.hermes
FileSystem-Memory.hermes
Compression.hermes --no-fail-on-undeclared
FileSystem-Zip.hermes
Multilingual-Encodings.hermes
Multilingual-Languages.hermes --no-fail-on-undeclared
Multilingual-TextConversion.hermes --no-fail-on-undeclared
Text-Core.hermes --no-fail-on-undeclared
AST-Core.hermes  --on-duplication=ignore --no-fail-on-undeclared
Debugging-Core.hermes --no-fail-on-undeclared
OpalCompiler-Core.hermes  --on-duplication=ignore
../bootstrap/TraitsV2.hermes
Kernel-Traits.hermes
AST-Core-Traits.hermes
Collections-Abstract-Traits.hermes
Transcript-Core-Traits.hermes
TraitsV2-Compatibility.hermes
Alien-Core.hermes
System-Model.hermes
PragmaCollector.hermes 
UnifiedFFI.hermes --on-duplication=ignore
Fonts-Abstract.hermes
Fonts-Infrastructure.hermes --no-fail-on-undeclared
Graphics-Primitives.hermes --no-fail-on-undeclared
Graphics-Transformations.hermes
Graphics-Canvas.hermes --no-fail-on-undeclared
Graphics-Display-Objects.hermes --no-fail-on-undeclared
FreeType.hermes --no-fail-on-undeclared
EmbeddedFreeType.hermes
Text-Scanning.hermes --no-fail-on-undeclared
Multilingual-OtherLanguages.hermes --no-fail-on-undeclared
Multilingual-TextConverterOtherLanguages.hermes
Graphics-Fonts.hermes --no-fail-on-undeclared
System-FileRegistry.hermes
Graphics-Files.hermes --no-fail-on-undeclared
Graphics-Shapes.hermes
System-Clipboard.hermes
Slot-Core.hermes --on-duplication=ignore
System-Localization.hermes
StartupPreferences.hermes
MenuRegistration.hermes --no-fail-on-undeclared
Keymapping-Core.hermes --no-fail-on-undeclared
Keymapping-KeyCombinations.hermes
STON-Core.hermes
System-OSEnvironments.hermes
System-VMEvents.hermes --no-fail-on-undeclared
Network-Kernel.hermes
UnifiedFFI-Legacy.hermes
Regex-Core.hermes
Math-Operations-Extensions.hermes
Morphic-Core.hermes --no-fail-on-undeclared
OSWindow-Core.hermes --no-fail-on-undeclared
OSWindow-VM.hermes
OSWindow-SDL2.hermes --no-fail-on-undeclared
System-Caching.hermes
System-History.hermes
Balloon.hermes --no-fail-on-undeclared
Morphic-Base.hermes --no-fail-on-undeclared
Morphic-Widgets-Extra.hermes
Morphic-Widgets-Scrolling.hermes --no-fail-on-undeclared
Morphic-Widgets-Basic.hermes
Morphic-Widgets-Windows.hermes  --no-fail-on-undeclared
Morphic-Widgets-ColorPicker.hermes
Morphic-Widgets-List.hermes
Morphic-Widgets-Menubar.hermes
Morphic-Widgets-PolyTabs.hermes
Morphic-Widgets-Tabs.hermes
Morphic-Widgets-Pluggable.hermes --no-fail-on-undeclared
Morphic-Widgets-Tree.hermes --no-fail-on-undeclared
Text-Diff.hermes
Text-Edition.hermes --no-fail-on-undeclared
Polymorph-Widgets.hermes --no-fail-on-undeclared
Rubric.hermes --no-fail-on-undeclared
Morphic-Widgets-FastTable.hermes
Morphic-Widgets-Taskbar.hermes
Morphic-Widgets-TickList.hermes
CodeImportCommandLineHandlers.hermes
Images-Animated.hermes
Transcript-Core.hermes
Shout.hermes
Fonts-Chooser.hermes
Tool-FileList.hermes
System-Sound.hermes
System-Object-Events.hermes
EOF
# external lib at Math-Operations-Extensions.hermes
# install package
while read cmd; do
    echo "loading $cmd"
    $VM $IMG loadHermes $BASE_DIR/tmp/$cmd --save --quit
done < /tmp/packages.txt
