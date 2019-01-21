include(ExternalProject)

if(DEFINED RELEASE_NAME)
ExternalProject_Add(
        kicad
        PREFIX  kicad
        DEPENDS python wxpython wxwidgets six ngspice docs
        GIT_REPOSITORY ${KICAD_URL}
        GIT_TAG ${KICAD_TAG}
        UPDATE_COMMAND          git fetch
        COMMAND                 echo "Making sure we aren't in the middle of a crashed git-am"
        COMMAND                 git am --abort || true
        COMMAND                 git reset --hard ${KICAD_TAG}
#        COMMAND                 ${BIN_DIR}/multipatch.py -p1 -- ${CMAKE_SOURCE_DIR}/patches/kicad/*.patch
        COMMAND                 ${BIN_DIR}/git-multipatch.sh ${CMAKE_SOURCE_DIR}/patches/kicad/*.patch
        COMMAND                 git tag -a ${RELEASE_NAME} -m "${RELEASE_NAME}"
        CMAKE_ARGS  ${KICAD_CMAKE_ARGS}
)
else()
ExternalProject_Add(
        kicad
        PREFIX  kicad
        DEPENDS python wxpython wxwidgets six ngspice docs
        GIT_REPOSITORY ${KICAD_URL}
        GIT_TAG ${KICAD_TAG}
        UPDATE_COMMAND          git fetch
        COMMAND                 echo "Making sure we aren't in the middle of a crashed git-am"
        COMMAND                 git am --abort || true
        COMMAND                 git reset --hard ${KICAD_TAG}
#        COMMAND                 ${BIN_DIR}/multipatch.py -p1 -- ${CMAKE_SOURCE_DIR}/patches/kicad/*.patch
        COMMAND                 ${BIN_DIR}/git-multipatch.sh ${CMAKE_SOURCE_DIR}/patches/kicad/*.patch
        CMAKE_ARGS  ${KICAD_CMAKE_ARGS}
)
endif()

ExternalProject_Add_Step(
        kicad
        install-docs-to-app
        COMMENT "Installing docs into KiCad.app"
        DEPENDEES install
        COMMAND mkdir -p ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help/
        COMMAND cp -r ${CMAKE_BINARY_DIR}/docs/share/doc/kicad/help/en ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help/
        COMMAND find ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help -name "*.epub" -type f -delete
        COMMAND find ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help -name "*.pdf" -type f -delete
)

ExternalProject_Add_Step(
        kicad
        verify-app
        COMMENT "Checking that all loader dependencies are system-provided or relative"
        DEPENDEES install
        COMMAND ${BIN_DIR}/verify-app.sh ${KICAD_INSTALL_DIR}/kicad.app
)

ExternalProject_Add_Step(
        kicad
        verify-cli-python
        COMMENT "Checking bin/python and bin/pythonw"
        DEPENDEES install
        COMMAND ${BIN_DIR}/verify-cli-python.sh ${KICAD_INSTALL_DIR}/kicad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/pythonw
        COMMAND ${BIN_DIR}/verify-cli-python.sh ${KICAD_INSTALL_DIR}/kicad.app/Contents/Frameworks/Python.framework/Versions/2.7/bin/pythonw
        COMMAND ${BIN_DIR}/verify-cli-python.sh ${KICAD_INSTALL_DIR}/kicad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python
        COMMAND ${BIN_DIR}/verify-cli-python.sh ${KICAD_INSTALL_DIR}/kicad.app/Contents/Frameworks/Python.framework/Versions/2.7/bin/python
)

ExternalProject_Add_Step(
        kicad
        remove-pyc-and-pyo
        COMMENT "Removing pyc and pyo files"
        DEPENDEES verify-cli-python install-six
        COMMAND find ${KICAD_INSTALL_DIR}/kicad.app/ -type f -name \*.pyc -o -name \*.pyo -delete
)

ExternalProject_Add_Step(
        kicad
        install-six
        COMMENT "Installing six into PYTHONPATH for easier debugging"
        DEPENDEES install
        COMMAND cp ${six_DIR}/six.py ${KICAD_INSTALL_DIR}/kicad.app/Contents/Frameworks/python/site-packages/
)

ExternalProject_Add_Step(
        kicad
        fixup-pcbnew-so
        COMMENT "Fixing loader dependencies so _pcbnew.so works both internal and external to KiCad."
        DEPENDEES install
        COMMAND ${BIN_DIR}/fixup-pcbnew-so.sh  ${KICAD_INSTALL_DIR}/kicad.app/Contents/Frameworks/
)

ExternalProject_Add_Step(
	kicad
	verify-pcbnew-so-import
	COMMENT "Verifying python can import _pcbnew.so"
	DEPENDEES fixup-pcbnew-so install-six remove-pyc-and-pyo verify-cli-python verify-app
	COMMAND ${BIN_DIR}/verify-pcbnew-so-import.sh  ${KICAD_INSTALL_DIR}/kicad.app/
)
