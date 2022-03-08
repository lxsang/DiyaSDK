#! /bin/bash
W=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
echo "Add $W to PATH"
export PATH="$W/bin:$PATH"
diya --help