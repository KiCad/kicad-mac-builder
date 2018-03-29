include (ExternalProject)

ExternalProject_Add(
        kicad
        PREFIX  kicad
        DEPENDS python wxpython wxwidgets
        GIT_REPOSITORY ${KICAD_URL}
        GIT_TAG ${KICAD_TAG}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CMAKE_ARGS  ${KICAD_CMAKE_ARGS}
)

ExternalProject_Add_Step(
        kicad
        install-docs-to-app
        COMMENT "Installing docs into KiCad.app"
        DEPENDEES install
        DEPENDS kicad docs
        COMMAND mkdir -p ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help/
        COMMAND cp -r ${CMAKE_BINARY_DIR}/docs/kicad-doc-HEAD/share/doc/kicad/help/en ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help/
        COMMAND find ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help -name "*.epub" -type f -delete
        COMMAND find ${KICAD_INSTALL_DIR}/kicad.app/Contents/SharedSupport/help -name "*.pdf" -type f -delete
)
