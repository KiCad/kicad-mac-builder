#!/bin/bash

# Many thanks to metacollin.

if [ $# -ne 1 ] ; then
   echo "bad number of arguments, must pass Frameworks directory"
   exit 1
fi

if [ ! -d "$1/python/site-packages" ]; then
   echo "$1/python/site-packages doesn't appear to exist.  exiting."
   exit 1
fi

cd "$1"

for file in *.dylib; do
    fixup_libs=($(otool -L $file | grep -o "@executable_path.*.dylib"));
    libs=($(echo ${fixup_libs[@]} | grep -o "[^/]*dylib"));
    for ((i=0;i<${#fixup_libs[@]};++i)); do
        install_name_tool -change "${fixup_libs[i]}" "@rpath/${libs[i]}" $file;
    done;
    install_name_tool -add_rpath @loader_path/../.. -add_rpath @executable_path/../Frameworks $file;
done;

cd python/site-packages

fixup_libs=($(otool -L _pcbnew.so | grep -o "@executable_path.*.dylib"));
libs=($(echo ${fixup_libs[@]} | grep -o "[^/]*dylib"));
for ((i=0;i<${#fixup_libs[@]};++i)); do
    install_name_tool -change "${fixup_libs[i]}" "@rpath/${libs[i]}" _pcbnew.so;
done

install_name_tool -add_rpath @loader_path/../.. -add_rpath @executable_path/../Frameworks _pcbnew.so

echo "done"
