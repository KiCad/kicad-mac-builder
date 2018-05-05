#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Bad number of arguments, expects glob of patches"
    exit 1
fi


for file in $1; do
    if [ ! -e "$file" ]; then
        echo "Unable to find files at $1"
        exit 1
    fi

    git am "$file"
    EXITCODE=$?
    if [ $EXITCODE -ne 0 ]; then
        echo "Problem while applying patch $1"
        exit $EXITCODE
    fi

    git status | grep "^You are in the middle of an am session" > /dev/null
    EXITCODE=$?
    if [ $EXITCODE -eq 1 ]; then
       exit 0
    else
       echo "Something is wrong in your build/kicad/src/kicad directory. Exiting."
       exit 1
    fi
done
