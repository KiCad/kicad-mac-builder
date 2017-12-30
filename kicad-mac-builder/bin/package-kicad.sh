#!/bin/bash

set -e

#TODO: should most of this happen in a tempdir, rather than in the build dir? (I think so...?)

#if [ "${VERBOSE}" ]; then
    set -x
#fi

echo "PACKAGING_DIR: $PACKAGING_DIR"
echo "KICAD_INSTALL_DIR: $KICAD_INSTALL_DIR"
echo "VERBOSE: $VERBOSE"
echo "TEMPLATE: $TEMPLATE"
echo "SUPPORT_DIR: $SUPPORT_DIR"
echo "pwd: `pwd`"

if [ ! -e "${PACKAGING_DIR}" ]; then
    echo "PACKAGING_DIR must be set and exist."
    exit 1
fi

if [ ! -e "${SUPPORT_DIR}" ]; then
    echo "SUPPORT_DIR must be set and exist."
    exit 1
fi

if [ -z "${TEMPLATE}" ]; then
    echo "TEMPLATE must be set."
    exit 1
fi

if [ ! -e "${KICAD_INSTALL_DIR}" ]; then
    echo "KICAD_INSTALL_DIR must be set and exist."
    exit 1
fi

NOW=`date +%Y%m%d-%H%M%S`

FINAL_DMG_DEST=../dmg
KICAD_REVNO=abc
KICAD_APPS=./bin
NEW_DMG=kicad.uncompressed.dmg
MOUNTPOINT=kicad-mnt
FINAL_DMG=kicad-$NOW.$KICAD_REVNO-KMB.dmg

# make the mountpoint
if [ -e $MOUNTPOINT ]; then
    # it might be a leftover mount from a crashed previous run, so try to unmount it before removing it.
    diskutil unmount $MOUNTPOINT || true
    rm -r $MOUNTPOINT
fi
mkdir -p $MOUNTPOINT

# untar the template
if [ -e $TEMPLATE ]; then
    rm $TEMPLATE
fi
tar xf $PACKAGING_DIR/$TEMPLATE.tar.bz2
if [ ! -e $TEMPLATE ]; then
    echo "Unable to find $TEMPLATE"
    exit 1
fi

# resize the template, and mount it
hdiutil resize -size 2.5G $TEMPLATE
hdiutil attach $TEMPLATE -noautoopen -mountpoint $MOUNTPOINT

mkdir -p $MOUNTPOINT/Kicad # TODO: do we switch this to KiCad?


rsync -al $KICAD_INSTALL_DIR/* $MOUNTPOINT/Kicad/. # IMPORTANT: must preserve symlinks

# update background of the DMG
cp $PACKAGING_DIR/background.png $MOUNTPOINT/.
# Rehide the background file
SetFile -a V $MOUNTPOINT/background.png

#copy in support files
cp -r $SUPPORT_DIR $MOUNTPOINT/kicad

#support/modules is in the base package
#extras/modules is in the extras package

#TODO: reevalulate all of the modules/packages3d stuff for V5

#this causes a problem with defaults, and changing the default
#was ugly, so we're going to do something way, way uglier here
# we are going to make modules, and put a symlink to ../packages3d there
# and we are going to do it inside of extras/modules too.

#mkdir -p $MOUNTPOINT/kicad/modules
#cd $MOUNTPOINT/kicad/modules
#ln -s ../packages3d
#echo "KiCad uses footprints from Github.  These have been packaged for offline use, and can be added using the kicad-extras dmg at https://download.kicad-pcb.org/osx" > README
#cd -

#cp README.template $MOUNTPOINT/README.txt
#if [ -e ../notes/build.log ]; then
#    cp ../notes/build.log ../notes/build.$NOW.log
#    cp ../notes/build.$NOW.log $MOUNTPOINT/build.$NOW.log
#fi

#Update README
#echo "" >> $MOUNTPOINT/README.txt
#echo "About This Build" >> $MOUNTPOINT/README.txt
#echo "================" >> $MOUNTPOINT/README.txt
#echo "Packaged on $NOW" >> $MOUNTPOINT/README.txt
#echo "KiCad revision: r$KICAD_REVNO" >> $MOUNTPOINT/README.txt

#if [ -f ../notes/cmake_settings ]; then
#    echo "KiCad CMake Settings: `cat ../notes/cmake_settings`" >> $MOUNTPOINT/README.txt
#fi

#if [ -f ../notes/kicad_patches ]; then
#    echo "KiCad patched with following patches:" >> $MOUNTPOINT/README.txt
#    cat ../notes/kicad_patches >> $MOUNTPOINT/README.txt
#fi

#if [ -f ../notes/docs_revno ]; then
#    echo "Docs revision: r`cat ../notes/docs_revno`" >> $MOUNTPOINT/README.txt
#fi

#if [ -f ../notes/docs_revno ]; then
#    echo "Libraries revision: r`cat ../notes/libs_revno`" >> $MOUNTPOINT/README.txt
#fi

#if [ -f ../notes/build_revno ]; then
#    echo "Build script revision: r`cat ../notes/build_revno`" >> $MOUNTPOINT/README.txt
#fi

#if bzr revno; then
#    echo "Packaging script revision: r`bzr revno`" >> $MOUNTPOINT/README.txt
#fi

#cp $MOUNTPOINT/README.txt ../notes/README #So we can archive the generated README outside of the DMG as well

echo "Unmounting the dmg and cleaning up."
# Unmount the DMG, and clean up
hdiutil detach $MOUNTPOINT
rm -r $MOUNTPOINT

#set it so the DMG autoopens on download/mount
hdiutil attach $TEMPLATE -noautoopen -mountpoint /Volumes/KiCad
bless /Volumes/KiCad --openfolder /Volumes/KiCad
hdiutil detach /Volumes/KiCad

# if the end DMG exists already, delete it.

if [ -e $FINAL_DMG ] ; then
    rm -r $FINAL_DMG
fi

#compress the DMG
#hdiutil convert $TEMPLATE  -format UDBZ -imagekey -o $FINAL_DMG #bzip2 based is a little bit smaller, but opens much, much slower.
hdiutil convert $TEMPLATE  -format UDZO -imagekey zlib-level=9 -o $FINAL_DMG #This used zlib, and bzip2 based (above) is slower but more compression

# cleanup the template file
rm $TEMPLATE

mkdir -p $FINAL_DMG_DEST
mv $FINAL_DMG $FINAL_DMG_DEST/

echo "Done creating $FINAL_DMG in $FINAL_DMG_DEST"