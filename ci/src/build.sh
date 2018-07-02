#!/bin/bash

set +e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $SCRIPT_DIR/../../

./build.sh "$@" && exit 0  # exiting because everything succeeded.

echo "Cleaning build directory since original build failed."
rm -rf build/

echo "Building again."
./build.sh --NUM_CORES=1 "$@"
