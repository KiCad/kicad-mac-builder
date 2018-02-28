cmake_minimum_required(VERSION 3.8)
include(ExternalProject)

set(CMAKE_VERBOSE_MAKEFILE ON)

set(BIN_DIR ${CMAKE_SOURCE_DIR}/bin)

set( PYTHON_VERSION 2.7.13)
set( PYTHON_URL https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz )
set( PYTHON_SHA1 dce2b862a30099ee48c19a7c34e2d7c2eeff5670 )
set( PYTHON_INSTALL_DIR ${CMAKE_BINARY_DIR}/python-dest )
include(python.cmake)



set( WXPYTHON_VERSION 3.0.2.0)
set( WXPYTHON_URL http://downloads.sourceforge.net/project/wxpython/wxPython/${WXPYTHON_VERSION}/wxPython-src-${WXPYTHON_VERSION}.tar.bz2 )
set( WXPYTHON_SHA1 5053f3fa04f4eb3a9d4bfd762d963deb7fa46866 )
set( wxwidgets_INSTALL_DIR ${CMAKE_BINARY_DIR}/wxwidgets-dest)
set( wxpython_INSTALL_DIR ${CMAKE_BINARY_DIR}/wxpython-dest)
include(wxpython.cmake)

set( KICAD_URL https://git.launchpad.net/kicad)
set( KICAD_TAG master)
set( KICAD_INSTALL_DIR ${CMAKE_BINARY_DIR}/kicad-dest)
set( KICAD_CMAKE_ARGS -DDEFAULT_INSTALL_PATH=/Library/Application Support/kicad -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOS_MIN_VERSION} -DwxWidgets_CONFIG_EXECUTABLE=${wxwidgets_INSTALL_DIR}/bin/wx-config  -DKICAD_SCRIPTING=ON  -DKICAD_SCRIPTING_MODULES=OFF  -DKICAD_SCRIPTING_WXPYTHON=ON  -DPYTHON_EXECUTABLE=${PYTHON_INSTALL_DIR}/bin/python2.7  -DPYTHON_INCLUDE_DIR=${PYTHON_INSTALL_DIR}/include/python2.7/ -DPYTHON_LIBRARY=${PYTHON_INSTALL_DIR}/lib/libpython2.7.dylib  -DPYTHON_SITE_PACKAGE_PATH=${wxwidgets_INSTALL_DIR}/lib/python2.7/site-packages -DCMAKE_INSTALL_PREFIX=${KICAD_INSTALL_DIR} -DKICAD_SPICE=OFF -DKICAD_USE_OCE=OFF -DCMAKE_BUILD_TYPE=Release )

set( SUPPORT_DIR ${CMAKE_BINARY_DIR}/ApplicationSupport )
set( EXTRAS_DIR ${CMAKE_BINARY_DIR}/Extras )

include(kicad.cmake)

include(docs.cmake)

set( TRANSLATIONS_URL https://github.com/KiCad/kicad-i18n.git)
set( TRANSLATIONS_TAG master)
include(translations.cmake)

include(footprints.cmake)
include(symbols.cmake)
include(templates.cmake)
include(packages3d.cmake)

include(package_kicad.cmake)
include(package_extras.cmake)
