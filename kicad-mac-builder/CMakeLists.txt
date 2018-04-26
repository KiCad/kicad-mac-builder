cmake_minimum_required( VERSION 3.6.2 )
include( ExternalProject )
if( NOT DEFINED MACOS_MIN_VERSION )
message( FATAL_ERROR "MACOS_MIN_VERSION must be set.  For example 'cmake -DMACOS_MIN_VERSION=10.13 ../kicad-mac-builder'" )
endif ()

set( CMAKE_VERBOSE_MAKEFILE ON )
set( BIN_DIR ${CMAKE_SOURCE_DIR}/bin )

set( PYTHON_VERSION 2.7.13 )
set( PYTHON_URL https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz )
set( PYTHON_SHA1 dce2b862a30099ee48c19a7c34e2d7c2eeff5670 )
set( PYTHON_INSTALL_DIR ${CMAKE_BINARY_DIR}/python-dest/Library/Frameworks ) # Ending in /Library/Frameworks is important here
include( python.cmake )

set( WXPYTHON_VERSION 3.0.2.0 )
# set(WXPYTHON_URL http://downloads.sourceforge.net/project/wxpython/wxPython/${WXPYTHON_VERSION}/wxPython-src-${WXPYTHON_VERSION}.tar.bz2 )
set( WXPYTHON_URL ${CMAKE_SOURCE_DIR}/../external/wxPython-src-${WXPYTHON_VERSION}.tar.bz2 )
set( WXPYTHON_SHA1 5053f3fa04f4eb3a9d4bfd762d963deb7fa46866 )
set( wxwidgets_INSTALL_DIR ${CMAKE_BINARY_DIR}/wxwidgets-dest )
set( wxpython_INSTALL_DIR ${CMAKE_BINARY_DIR}/wxpython-dest )
include( wxpython.cmake )

set( KICAD_URL https://git.launchpad.net/kicad )
set( KICAD_TAG master )
set( KICAD_INSTALL_DIR ${CMAKE_BINARY_DIR}/kicad-dest )

# find OCE
execute_process(COMMAND brew --cellar oce OUTPUT_VARIABLE OCE_BASEDIR RESULT_VARIABLE FOUND_OCE_BASEDIR_EXIT_CODE OUTPUT_STRIP_TRAILING_WHITESPACE)
if (NOT ${FOUND_OCE_BASEDIR_EXIT_CODE} EQUAL 0)
  message( FATAL_ERROR "Unable to find OCE's base directory from brew.  Make sure you have installed all the dependencies per the README. Exiting." )
endif()
execute_process(COMMAND find ${OCE_BASEDIR} -name Resources OUTPUT_VARIABLE OCE_DIR RESULT_VARIABLE FOUND_OCE_EXIT_CODE)
if (NOT ${FOUND_OCE} EQUAL 0)
  message( FATAL_ERROR "Unable to find Resources in ${OCE_BASEDIR}.  Make sure you have installed all the dependencies per the README. Exiting." )
endif()

set( KICAD_CMAKE_ARGS -DDEFAULT_INSTALL_PATH=/Library/Application\ Support/kicad -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOS_MIN_VERSION} -DwxWidgets_CONFIG_EXECUTABLE=${wxwidgets_INSTALL_DIR}/bin/wx-config  -DKICAD_SCRIPTING=ON  -DKICAD_SCRIPTING_MODULES=OFF  -DKICAD_SCRIPTING_WXPYTHON=ON  -DPYTHON_EXECUTABLE=${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/bin/python2.7  -DPYTHON_INCLUDE_DIR=${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/include/python2.7/ -DPYTHON_LIBRARY=${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/lib/libpython2.7.dylib  -DPYTHON_SITE_PACKAGE_PATH=${wxwidgets_INSTALL_DIR}/lib/python2.7/site-packages -DCMAKE_INSTALL_PREFIX=${KICAD_INSTALL_DIR} -DKICAD_SPICE=ON -DKICAD_USE_OCE=ON -DOCE_DIR=${OCE_DIR} -DCMAKE_BUILD_TYPE=Release )

set( DMG_DIR ${CMAKE_BINARY_DIR}/dmg )

include( kicad.cmake )
include( docs.cmake )

set( TRANSLATIONS_URL https://github.com/KiCad/kicad-i18n.git )
set( TRANSLATIONS_TAG master )
include( translations.cmake )

include( footprints.cmake )
include( symbols.cmake )
include( templates.cmake )
include( packages3d.cmake )

include( package_kicad_nightly.cmake )
include( package_kicad_unified.cmake )
include( package_extras.cmake )
