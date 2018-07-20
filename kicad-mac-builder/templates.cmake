ExternalProject_Add(
        templates
        PREFIX  templates
        GIT_REPOSITORY https://github.com/kicad/templates.git
        GIT_TAG ${TEMPLATES_TAG}
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<BINARY_DIR>/output"
)
