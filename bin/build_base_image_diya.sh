#! /bin/bash
set -e
set -x
[ -z "$1" ] && echo "Please specify 32 or 64 bits architectuure" && exit 1
echo "[Compiler] Adding more Kernel packages"
ARCH="$1"
W=$(realpath "$(dirname "$(realpath "$0")")/../")
BASE_DIR="$W/$ARCH"
rm "$BASE_DIR/tmp" -rf
mkdir -p "$BASE_DIR/tmp/"
cp "$BASE_DIR/bootstrap/bootstrap.image" "$BASE_DIR/tmp/diya.image"
cp "$W"/unicode/* "$BASE_DIR/tmp/"
cp -rf "$W"/fonts "$BASE_DIR"/tmp/ 
VM="$BASE_DIR/builder/pharo"
IMG="$BASE_DIR/tmp/diya.image"
SRC_IMG="$BASE_DIR/builder/Pharo.image"

if [ ! -e "$SRC_IMG" ]; then
    mkdir -p "$BASE_DIR/builder/"
    cd "$BASE_DIR/builder/"
    curl "https://get.pharo.org/$ARCH/70+vm" | bash
    cd "$W"
fi
cp -rf "$W/fonts" "$BASE_DIR/builder/" 

$VM "$SRC_IMG" "$W/install.st" --quit
NAME="Diya-Bootstrap"
$VM "$SRC_IMG" "$W/export.st" "$BASE_DIR/tmp" "$NAME" --quit
echo "Creating image...."

$VM "$IMG"
$VM "$IMG" loadHermes "$BASE_DIR/bootstrap/Hermes-Extensions.hermes" \
        "$BASE_DIR/bootstrap/TraitsV2.hermes" \
        "$BASE_DIR/tmp/$NAME.hermes" --on-duplication=ignore \
        --no-fail-on-undeclared --save --quit

#init the image
$VM "$IMG" init --save
