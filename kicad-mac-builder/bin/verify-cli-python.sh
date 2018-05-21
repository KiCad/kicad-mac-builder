#!/bin/bash

if [ ! -e "$1" ]; then
  exit 1
fi

# I do not understand why this top check is ever needed.  After July 2018, I should verify in the logs to see if this is still seen, and if not, remove it.

otool -L $1 | grep '@executable_path/../../Contents/MacOS/Python.framework/Versions/2.7/Python' > /dev/null
if [ "$?" -ne 1 ]; then
        echo "$1 appears to be incorrectly setup.  There is a bug where this does not occur in python-dest but does in kicad-dest, and as I am figuring it out, I am working around it here."
        echo "Trying to fix $1"
        install_name_tool -change @executable_path/../../Contents/MacOS/Python.framework/Versions/2.7/Python "@rpath/Python.framework/Python" "$1"
        otool -L $1 | grep '@executable_path/../../Contents/MacOS/Python.framework/Versions/2.7/Python' > /dev/null
        if [ "$? -eq 1 ]; then
            echo "It appears to be fixed."
        fi
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
