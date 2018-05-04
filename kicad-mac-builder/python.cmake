include(ExternalProject)

# On not writing to /Applications or /bin during Python's make install:

# When you compile Python as a Framework, it wants to write into /Applications.
# The documentation implies you can get around it by building the frameworkinstallframework target
# but those end up pulling in frameworkinstallapps and frameworkinstallunixtools, which write into places we don't want~
# So I tried overriding where it was writing with DESTDIR.  I had issues when fixup_bundle ended up pulling in a good portion of my OS install!
# Third, I patched the Python Makefiles to not do apps and unixtools.  While doing so, I noticed that there was a special case:
# if the Framework path as foo/Library/Frameworks, it writes into foo/Applications.  BINGO!
# This means it is important that PYTHON_INSTALL_DIR end in /Library/Frameworks.

# I am seeing an issue where pcbnew's Python ends up being the SYSTEM PYTHON!  I used dtruss and DYLD_PRINT_* and a few other tools
# and a bunch of Mac developer reference tools, and it appears that there are some fallback dynamic loading locations that don't
# seem to match the documentation for macOS.

# For some reason, we need to do the install step with one core only.  I haven't found or created an upstream bug, but other people have run into something similar.
# https://github.com/Homebrew/legacy-homebrew/issues/429

# It would be nice to replace the steps below with install_name_tool with fixup_bundle, but I am not sure it is able to handle a bundle's embedded Framework that has an embedded application, and a different bundle that symlinks into the first one and masquerades as a standalone bundle.  I tried for a few days and was unsuccessful.

# KiCad's CMakefile runs fixup_bundle, which runs verify_app, which verifies all the components, and every time I did this with rpath, verify_app chokes on Python here, saying that it isn't contained in KiCad.app.  I am not 100% sure, because I had to pause chasing this down once I figured out a workaround until all of kicad-mac-builder is closer to functional before V5 comes out.  One workaround is adding the Python parts as IGNORE_ITEMS in KiCad's CMakefile.  Make sure to check out the KiCad patch in kicad-mac-builder/patches/kicad.

# If someone can get BundleUtilities to replace the manual install_name_tool step I'd love to see it!

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
        PATCH_COMMAND ${BIN_DIR}/multipatch.py -p1 -- ${CMAKE_SOURCE_DIR}/patches/python/*.patch
        INSTALL_COMMAND make -j1 install
)


ExternalProject_Add_Step(
        python
        fixup
        COMMENT "Fixing up the Python framework"
        DEPENDEES install

        COMMAND install_name_tool -change "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Python" "@rpath/Python.framework/Python" "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python"
        COMMAND ${BIN_DIR}/add-rpath.sh @executable_path/../Frameworks "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python" # for the kifaces
        COMMAND ${BIN_DIR}/add-rpath.sh @executable_path/../../../../../../../ "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python" # for the bin/python files
        COMMAND ${BIN_DIR}/add-rpath.sh @executable_path/../../../../../ ${PYTHON_INSTALL_DIR}/Python.framework/Resources/Python.app/Contents/MacOS/Python

        COMMAND install_name_tool -change "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Python" "@rpath/Python.framework/Python" "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/bin/python"
        COMMAND ${BIN_DIR}/add-rpath.sh @executable_path/../../../../ "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/bin/python"

        COMMAND install_name_tool -change "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/Python" "@rpath/Python.framework/Python" "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/bin/pythonw"
        COMMAND ${BIN_DIR}/add-rpath.sh @executable_path/../../../../ "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/bin/pythonw"

        COMMAND chmod u+w "${PYTHON_INSTALL_DIR}/Python.framework/Python"
        COMMAND install_name_tool -id @rpath/Python.framework/Python "${PYTHON_INSTALL_DIR}/Python.framework/Python"
)

ExternalProject_Add_Step(
	python
	verify
	COMMENT "Test bin/python and bin/pythonw"
	DEPENDEES fixup
	COMMAND ${BIN_DIR}/verify-cli-python.sh "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/bin/pythonw"
	COMMAND ${BIN_DIR}/verify-cli-python.sh "${PYTHON_INSTALL_DIR}/Python.framework/Versions/2.7/bin/python"
)

ExternalProject_Add(
        six
        PREFIX six
        GIT_REPOSITORY https://github.com/benjaminp/six.git
        GIT_TAG 1.11.0
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ""
        BUILD_COMMAND       ""
        INSTALL_COMMAND     ""
        UPDATE_DISCONNECTED 1
)
