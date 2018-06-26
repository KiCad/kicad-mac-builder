#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $SCRIPT_DIR/../../

./build.sh "$@"
EXITCODE=$?
if [ ${EXITCODE} -eq 0 ]; then
    exit 0
fi

echo "Cleaning build directory since original build failed."
rm -rf build/

echo "Building again."
./build.sh --NUM_CORES=1 "$@"
