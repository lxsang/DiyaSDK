Hermes-Extensions.hermes # load from base bootstrap
Kernel-Chronology-Extras.hermes
Jobs.hermes
Collections-Arithmetic.hermes
Collections-Atomic.hermes
Collections-DoubleLinkedList.hermes
Zinc-Resource-Meta-Core.hermes
Zinc-Character-Encoding-Core.hermes --no-fail-on-undeclared --on-duplication=ignore
FileSystem-Core.hermes --no-fail-on-undeclared 
FileSystem-Disk.hermes
FileSystem-Memory.hermes
Compression.hermes --no-fail-on-undeclared
FileSystem-Zip.hermes
Multilingual-Encodings.hermes
Multilingual-Languages.hermes --no-fail-on-undeclared
Multilingual-TextConversion.hermes
# we need the kernel to update things
Kernel.hermes --no-fail-on-undeclared --on-duplication=ignore
Text-Core.hermes --no-fail-on-undeclared
Fonts-Abstract.hermes
Fonts-Infrastructure.hermes --no-fail-on-undeclared
AST-Core.hermes  --on-duplication=ignore --no-fail-on-undeclared
Debugging-Core.hermes --no-fail-on-undeclared
OpalCompiler-Core.hermes  --on-duplication=ignore
Alien-Core.hermes
System-Model.hermes
PragmaCollector.hermes 
UnifiedFFI.hermes --on-duplication=ignore
Graphics-Primitives.hermes --no-fail-on-undeclared
Graphics-Transformations.Hermes
Graphics-Canvas.hermes --no-fail-on-undeclared
Graphics-Display-Objects.hermes --no-fail-on-undeclared
TraitsV2 --on-duplication=ignore# from boot strap WARN we may not need this
TraitsV2 --on-duplication=ignore # from new system WARN we may not need this
FreeType --no-fail-on-undeclared
EmbeddedFreeType
Text-Scanning.hermes
loadHermes Multilingual-OtherLanguages.hermes --no-fail-on-undeclared
Multilingual-TextConverterOtherLanguages.hermes
# extra graphic support
