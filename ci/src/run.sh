#!/bin/bash

set -e
set -x

export PATH="${PATH}":/usr/local/opt/gettext/bin
NUM_CORES=$(sysctl -n hw.ncpu)

cd /vagrant

#if [ -e build ] ; then
#  rm -r build
#fi

mkdir -p build
cd build

export PATH=$PATH:/usr/local/opt/gettext/bin
cmake -DMACOS_MIN_VERSION="$(sw_vers -productVersion | cut -d. -f1-2)" ../kicad-mac-builder
make -j"${NUM_CORES}" package-kicad-nightly package-kicad-extras package-kicad-unified
echo "build succeeded."
