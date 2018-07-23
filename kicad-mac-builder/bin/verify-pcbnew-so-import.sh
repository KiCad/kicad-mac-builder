#!/bin/bash

if [ ! -e "$1" ]; then
  exit 1
fi

echo "Checking that importing pcbnew.so doesn't pull in a different Python or crash"

cd "$1/Contents/Frameworks/python/site-packages/"

DYLD_PRINT_LIBRARIES=1 DYLD_PRINT_LIBRARIES_POST_LAUNCH=1 ../../Python.framework/Versions/Current/bin/python -c 'import pcbnew ; print "Imported" + "Module" + "Successfully"' 2>&1 | grep /System/Library/Frameworks/Python.framework
if [ "$?" -ne 1 ]; then
	echo "$1 appears to call the System Python framework.  DYLD_PRINT_LIBRARIES=1 \"$1\" may help you debug the issue."
	exit 1
fi

DYLD_PRINT_LIBRARIES=1 DYLD_PRINT_LIBRARIES_POST_LAUNCH=1 ../../Python.framework/Versions/Current/bin/python -c 'import pcbnew ; print "Imported" + "Module" + "Successfully"' 2>&1 | grep ImportedModuleSuccessfully
if [ "$?" -ne 0 ]; then
	echo "Error importing pcbnew."
	exit 1
fi
