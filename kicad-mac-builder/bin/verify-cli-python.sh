#!/bin/bash

if [ ! -f "$1" ]; then
  exit 1
fi

DYLD_PRINT_LIBRARIES=1 "$1" -c 'print "Hello world."' 2>&1 | grep /System/Library/Frameworks/Python.framework
if [ "$?" -ne 1 ]; then
	echo "$1 appears to call the System Python framework.  DYLD_PRINT_LIBRARIES=1 "$1" may help you debug the issue."
	exit 1
fi
