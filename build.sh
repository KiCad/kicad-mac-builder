#!/bin/bash

set -e
set -x

mkdir -p build
cd build

NUM_CORES=`sysctl -n hw.ncpu`

export PATH=$PATH:/usr/local/opt/gettext/bin
cmake -DMACOS_MIN_VERSION=`sw_vers -productVersion | cut -d. -f1-2` ../kicad-mac-builder
make -j$NUM_CORES || make
echo "build succeeded."
