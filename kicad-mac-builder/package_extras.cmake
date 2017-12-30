cmake_minimum_required(VERSION 3.8)


# I don't like how I have to recreate <BINARY_DIR> of other targets here,
# but I didn't like it when the install aspect of this installed it into a temp directory either
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
                      EXTRAS_DIR=${EXTRAS_DIR}
                      ${BIN_DIR}/package-extras.sh
)

ExternalProject_Add_Step(
        package-extras
        install-packages3d-to-extras
        COMMENT "Installing packages3d into extras"
        DEPENDEES build
        DEPENDERS install
        DEPENDS packages3d
        COMMAND cp -r ${CMAKE_BINARY_DIR}/packages3d/src/packages3d-build ${EXTRAS_DIR}/packages3d
)

ExternalProject_Add_Step(
        package-extras
        instal-footprints-to-extras
        COMMENT "Installing footprints into extras"
        DEPENDEES build
        DEPENDERS install
        DEPENDS footprints
        COMMAND   cp -R ${CMAKE_BINARY_DIR}/footprints/src/footprints-build ${EXTRAS_DIR}/modules
)
