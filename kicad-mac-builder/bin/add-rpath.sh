#!/bin/bash

# install_name_tool produces an error when you try to add an rpath that already exists.

if [ $# -ne 2 ] ; then
   echo "bad number of arguments, must pass rpath and file"
   exit 1
fi

OUTPUT=$(install_name_tool -add_rpath "$1" "$2" 2>&1)
EXITCODE=$?
if [ $EXITCODE -eq 0 ]; then
   exit 0
elif [ $EXITCODE -eq 1 ]; then
   if echo "$OUTPUT" | grep 'would duplicate path, file already has LC_RPATH for' ; then
      exit 0
   fi
fi

echo "$OUTPUT"
exit $EXITCODE
