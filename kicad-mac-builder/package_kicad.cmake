ExternalProject_Add(
        package-kicad
        DEPENDS kicad symbols translations docs footprints templates
        PREFIX package-kicad
        DOWNLOAD_COMMAND ""
        UPDATE_COMMAND   ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND mkdir -p ${SUPPORT_DIR}
        INSTALL_COMMAND VERBOSE=1
                      PACKAGING_DIR=${CMAKE_SOURCE_DIR}/packaging
                      KICAD_INSTALL_DIR=${KICAD_INSTALL_DIR}
                      TEMPLATE=kicadtemplate.dmg
                      SUPPORT_DIR=${SUPPORT_DIR}
                      ${BIN_DIR}/package-kicad.sh
)

# I don't like how I have to recreate <INSTALL_DIR> of other targets here,

ExternalProject_Add_Step(
        package-kicad
        install-docs-to-support
        COMMENT "Installing docs into Application Support directory for disk image"
        DEPENDEES build
        DEPENDERS install
        DEPENDS docs
        COMMAND cp -r ${CMAKE_BINARY_DIR}/docs/kicad-doc-HEAD/share/doc/kicad/help ${SUPPORT_DIR}/
)


ExternalProject_Add_Step(
        package-kicad
        install-translations-to-support
        COMMENT "Installing translations into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS translations
        COMMAND mkdir -p ${SUPPORT_DIR}/share
        COMMAND cp -r ${CMAKE_BINARY_DIR}/translations/src/translations-build/output/share/kicad/internat ${SUPPORT_DIR}/share/
)

ExternalProject_Add_Step(
        package-kicad
        install-templates-to-support
        COMMENT "Installing templates into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS templates
        COMMAND mkdir -p ${SUPPORT_DIR}/share
        COMMAND cp -r ${CMAKE_BINARY_DIR}/templates/src/templates-build ${SUPPORT_DIR}/templates
)

ExternalProject_Add_Step(
        package-kicad
        install-symbols-to-support
        COMMENT "Installing symbols into support"
        DEPENDEES build
        DEPENDERS install
        DEPENDS symbols
        COMMAND cp -r ${CMAKE_BINARY_DIR}/symbols/src/symbols-build ${SUPPORT_DIR}/library
)
