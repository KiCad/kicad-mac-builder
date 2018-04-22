include(ExternalProject)

ExternalProject_Add(
        python
        PREFIX  python
        URL ${PYTHON_URL}
        URL_HASH SHA1=${PYTHON_SHA1}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND MACOSX_DEPLOYMENT_TARGET=${MACOS_MIN_VERSION} ./configure
                    --enable-framework=${PYTHON_INSTALL_DIR}
        BUILD_COMMAND make
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND make frameworkinstallframework
)

#include(BundleUtilities)
#fixup_bundle( ${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Resources/Python.app "" "")
# results in dyld: Library not loaded: @executable_path/../Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python
#  Referenced from: /Users/wolf/wnl/kicad/kicad-mac-builder/build/python-dest/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python
#  Reason: no suitable image found.  Did find:
#	/System/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python: not a dylib
#	/System/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python: not a dylib
#[1]    52659 abort

ExternalProject_Add_Step(
        python
        fixup
        COMMENT "Fixing up the Python framework"
        DEPENDEES install
        COMMAND install_name_tool -change "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Python" "@loader_path/../../../../Python" ${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python
)
