#!/bin/bash

set -e
set -x

cd /vagrant

#if [ -e build ] ; then
#  rm -r build
#fi

mkdir -p build
cd build

export PATH=$PATH:/usr/local/Cellar/gettext/*/bin
cmake -DMACOS_MIN_VERSION=`sw_vers -productVersion | cut -d. -f1-2` ../kicad-mac-builder
make -j4
make
