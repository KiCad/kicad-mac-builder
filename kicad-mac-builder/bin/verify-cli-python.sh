#!/bin/bash

if [ ! -e "$1" ]; then
  exit 1
fi

DYLD_PRINT_LIBRARIES=1 "$1" -c 'print "Hello world."' 2>&1 | grep /System/Library/Frameworks/Python.framework
if [ "$?" -ne 1 ]; then
	echo "$1 appears to call the System Python framework.  DYLD_PRINT_LIBRARIES=1 \"$1\" may help you debug the issue."
	exit 1
fi

"$1" -c 'print "Hello"+"World"' 2>&1 | grep HelloWorld > /dev/null
if [ "$?" -ne 0 ]; then
	echo "$1 did not appear to actually execute Python code.  Did it start up correctly?"
	exit 1
fi
