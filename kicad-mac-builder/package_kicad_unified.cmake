
ExternalProject_Add(
        package-kicad-unified
        DEPENDS kicad symbols translations docs footprints templates
        PREFIX package-kicad-unified
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND   ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND mkdir -p ${SUPPORT_DIR}
        INSTALL_COMMAND VERBOSE=1
                      PACKAGING_DIR=${CMAKE_SOURCE_DIR}/packaging
                      KICAD_INSTALL_DIR=${KICAD_INSTALL_DIR}
                      KICAD_SOURCE_DIR=${CMAKE_BINARY_DIR}/kicad/src/kicad
                      TEMPLATE=kicadtemplate.dmg
                      SUPPORT_DIR=${SUPPORT_DIR}
                      ${BIN_DIR}/package-kicad.sh
)

# I don't like how I have to recreate <INSTALL_DIR> of other targets here,
SET_TARGET_PROPERTIES(package-kicad-unified PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD True)

ExternalProject_Add_Step(
        package-kicad-unified
        install-docs-to-support
        COMMENT "Installing docs into Application Support directory for disk image"
        DEPENDEES build
        DEPENDERS install
        DEPENDS docs
        COMMAND cp -r ${CMAKE_BINARY_DIR}/docs/kicad-doc-HEAD/share/doc/kicad/help ${SUPPORT_DIR}/
)


ExternalProject_Add_Step(
        package-kicad-unified
        install-translations-to-support
        COMMENT "Installing translations into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS translations
        COMMAND mkdir -p ${SUPPORT_DIR}/share
        COMMAND cp -r ${CMAKE_BINARY_DIR}/translations/src/translations-build/output/share/kicad/internat ${SUPPORT_DIR}/share/
)

ExternalProject_Add_Step(
        package-kicad-unified
        install-templates-to-support
        COMMENT "Installing templates into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS templates
        COMMAND mkdir -p ${SUPPORT_DIR}/share
        COMMAND cp -r ${CMAKE_BINARY_DIR}/templates/src/templates-build ${SUPPORT_DIR}/templates
)

ExternalProject_Add_Step(
        package-kicad-unified
        install-symbols-to-support
        COMMENT "Installing symbols into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS symbols
        COMMAND cp -r ${CMAKE_BINARY_DIR}/symbols/src/symbols-build ${SUPPORT_DIR}/library
)

ExternalProject_Add_Step(
        package-kicad-unified
        install-packages3d-to-support
        COMMENT "Installing packages3d into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS packages3d
        COMMAND cp -r ${CMAKE_BINARY_DIR}/packages3d/src/packages3d-build ${SUPPORT_DIR}/packages3d
)

ExternalProject_Add_Step(
        package-kicad-unified
        install-footprints-to-support
        COMMENT "Installing footprints into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS footprints
        COMMAND   cp -R ${CMAKE_BINARY_DIR}/footprints/src/footprints-build ${SUPPORT_DIR}/modules
)
