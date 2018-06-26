ExternalProject_Add(
        packages3d
        PREFIX  packages3d
        GIT_REPOSITORY https://github.com/KiCad/kicad-packages3D.git
        #GIT_PROGRESS 1 #TODO uncomment when the official KiCad Mac gets updated...
        PATCH_COMMAND ""
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<BINARY_DIR>/output"
)
