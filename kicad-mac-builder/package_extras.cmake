# Maybe a better long term solution is to actually mount the DMG before we do this, and install directly into the DMG

ExternalProject_Add(
        package-extras
        DEPENDS packages3d footprints
        PREFIX package-extras
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND   ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND mkdir -p ${EXTRAS_DIR}
        INSTALL_COMMAND VERBOSE=1
                      PACKAGING_DIR=${CMAKE_SOURCE_DIR}/extras-packaging
                      TEMPLATE=kicad-extras-template.dmg
                      DMG_DIR=${DMG_DIR}
                      PACKAGE_TYPE=extras
                      CMAKE_BINARY_DIR=${CMAKE_BINARY_DIR}
                      ${BIN_DIR}/package.sh
)

SET_TARGET_PROPERTIES(package-extras PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD True)
