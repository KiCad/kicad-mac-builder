ExternalProject_Add(
        symbols
        PREFIX  symbols
        GIT_REPOSITORY https://github.com/KiCad/kicad-symbols.git
        PATCH_COMMAND ""
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<BINARY_DIR>/output"
)
