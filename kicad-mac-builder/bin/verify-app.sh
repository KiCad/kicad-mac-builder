#!/bin/bash

if [ ! -e "$1" ]; then
    exit 1
fi

echo "Checking $1 for non-relative and non-system references."
find "$1" -type f -print0 | xargs -0 otool -L 2>/dev/null | grep '^\t' | grep -v '^\t/usr/\|^\t/System/\|^\t@executable_path/\|^\t@rpath/\|^\t@loader_path/'
if [ "$?" -eq 1 ]; then
    echo "No issues found."
else
    echo "Issues found."
    echo "References with issues are indented."
    find "$1" -type f -print0 | xargs -0 otool -L 2>/dev/null | grep -v 'is not an object file' | grep -v '^\t/usr/\|^\t/System/\|^\t@executable_path/\|^\t@rpath/\|^\t@loader_path/'
    exit 1
fi
