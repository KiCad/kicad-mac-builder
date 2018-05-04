#!/bin/bash

set -e
set -x

GETTEXT_PATH="$(brew --prefix gettext)"/bin
BISON_PATH="$(brew --prefix bison)"/bin
export PATH="${BISON_PATH}":"${GETTEXT_PATH}":"${PATH}"
NUM_CORES=$(sysctl -n hw.ncpu)

mkdir -p build
cd build

cmake -DMACOS_MIN_VERSION="$(sw_vers -productVersion | cut -d. -f1-2)" ../kicad-mac-builder
if [ "$#" -eq 0 ]; then 
    make -j"${NUM_CORES}" package-kicad-unified package-kicad-nightly package-extras
else
    make -j"${NUM_CORES}" "$@"
fi
echo "build succeeded."
