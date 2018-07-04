
ExternalProject_Add(
        package-kicad-unified
        DEPENDS kicad symbols translations docs footprints templates packages3d
        PREFIX package-kicad-unified
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND   ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND VERBOSE=1
                      PACKAGING_DIR=${CMAKE_SOURCE_DIR}/unified-packaging
                      KICAD_SOURCE_DIR=${CMAKE_BINARY_DIR}/kicad/src/kicad
                      KICAD_INSTALL_DIR=${KICAD_INSTALL_DIR}
                      TEMPLATE=kicadtemplate.dmg
                      PACKAGE_TYPE=unified
                      CMAKE_BINARY_DIR=${CMAKE_BINARY_DIR}
                      README=${CMAKE_SOURCE_DIR}/README.packaging
                      DMG_DIR=${DMG_DIR}
                      RELEASE_NAME=${RELEASE_NAME}
                      ${BIN_DIR}/package.sh
)

SET_TARGET_PROPERTIES(package-kicad-unified PROPERTIES EXCLUDE_FROM_ALL True)

