ExternalProject_Add(
        footprints
        PREFIX  footprints
        GIT_REPOSITORY https://github.com/KiCad/kicad-footprints.git
        PATCH_COMMAND ""
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<BINARY_DIR>/output"
)
