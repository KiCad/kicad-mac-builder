#!/bin/bash

set -e

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}

SCRIPT_DIR=$(get_script_dir)

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
        echo "Changing ${fixup_libs[i]} to @rpath/${libs[i]} in $file"
        install_name_tool -change "${fixup_libs[i]}" "@rpath/${libs[i]}" $file;
    done;
    echo "Adding rpaths of @loader_path/../../ and @executable_path/../Frameworks to $file"
    #install_name_tool -add_rpath @loader_path/../.. -add_rpath @executable_path/../Frameworks $file;
    $SCRIPT_DIR/add-rpath.sh @loader_path/../.. $file;
    $SCRIPT_DIR/add-rpath.sh @executable_path/../Frameworks $file;
done;

cd python/site-packages

fixup_libs=($(otool -L _pcbnew.so | grep -o "@executable_path.*.dylib"));
libs=($(echo ${fixup_libs[@]} | grep -o "[^/]*dylib"));
for ((i=0;i<${#fixup_libs[@]};++i)); do
    echo "Changing ${fixup_libs[i]} to @rpath/${libs[i]} in _pcbnew.so"
    install_name_tool -change "${fixup_libs[i]}" "@rpath/${libs[i]}" _pcbnew.so;
done

echo "Adding rpaths of @loader_path/../../ and @executable_path/../Frameworks to _pcbnew.so"
#install_name_tool -add_rpath @loader_path/../.. -add_rpath @executable_path/../Frameworks _pcbnew.so
$SCRIPT_DIR/add-rpath.sh @loader_path/../.. _pcbnew.so
$SCRIPT_DIR/add-rpath.sh @executable_path/../Frameworks _pcbnew.so

echo "done"
