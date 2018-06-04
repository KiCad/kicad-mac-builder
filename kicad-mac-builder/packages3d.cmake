ExternalProject_Add(
        packages3d
        PREFIX  packages3d
        GIT_REPOSITORY https://github.com/KiCad/kicad-packages3D.git
        #GIT_PROGRESS 1
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND cp -Rf <SOURCE_DIR>/ <BINARY_DIR>/
        COMMAND chmod -R 750 <BINARY_DIR>/.git
        COMMAND rm -r <BINARY_DIR>/.git <BINARY_DIR>/.github
        COMMAND find <BINARY_DIR> -name .* -delete   # doesn't seem to work for non-empty directories
        INSTALL_COMMAND ""
)
