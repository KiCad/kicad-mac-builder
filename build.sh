#!/bin/bash

set -e
set -x

export PATH="${PATH}":/usr/local/opt/gettext/bin
NUM_CORES=$(sysctl -n hw.ncpu)

mkdir -p build
cd build

cmake -DMACOS_MIN_VERSION="$(sw_vers -productVersion | cut -d. -f1-2)" ../kicad-mac-builder
make -j"${NUM_CORES}" || make
echo "build succeeded."
