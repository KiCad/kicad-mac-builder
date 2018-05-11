#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Bad number of arguments, expects one glob"
    exit 1
fi

for file in $1; do
    echo "$file"
    if [ ! -e "${file}" ]; then
        echo "Unable to find file at $file"
        exit 1
    fi

    git am "${file}"
    EXITCODE=$?
    if [ $EXITCODE -ne 0 ]; then
        echo "Problem while applying patch ${file}"
        exit $EXITCODE
    fi

    git status | grep "^You are in the middle of an am session" > /dev/null
    EXITCODE=$?
    if [ $EXITCODE -ne 1 ]; then
       echo "Something is wrong in your build/kicad/src/kicad directory. Exiting."
       exit 1
    fi
done
