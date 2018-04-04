
ExternalProject_Add(
        package-kicad-nightly
        DEPENDS kicad symbols translations docs footprints templates
        PREFIX package-kicad-nightly
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND   ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND mkdir -p ${SUPPORT_DIR}
        INSTALL_COMMAND VERBOSE=1
                      PACKAGING_DIR=${CMAKE_SOURCE_DIR}/packaging
                      KICAD_SOURCE_DIR=${CMAKE_BINARY_DIR}/kicad/src/kicad
                      KICAD_INSTALL_DIR=${KICAD_INSTALL_DIR}
                      TEMPLATE=kicadtemplate.dmg
                      DMG_DIR=${DMG_DIR}
                      PACKAGE_TYPE=nightly
                      CMAKE_BINARY_DIR=${CMAKE_BINARY_DIR}
                      ${BIN_DIR}/package.sh
)

SET_TARGET_PROPERTIES(package-kicad-nightly PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD True)
