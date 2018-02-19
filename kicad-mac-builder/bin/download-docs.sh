#!/bin/bash

if [ ! -e "$1" ]; then
  echo "This script expects 1 argument, the destination for the files."
fi

rm -r "$1"/kicad-doc-HEAD
rm kicad-doc-HEAD.tar.gz
wget http://docs.kicad-pcb.org/master/kicad-doc-HEAD.tar.gz
tar -xvf kicad-doc-HEAD.tar.gz -C "$1"
