cmake_minimum_required(VERSION 3.8)

ExternalProject_Add(
        templates
        PREFIX  templates
        GIT_REPOSITORY https://github.com/SchrodingersGat/kicad-templates.git
        GIT_TAG copy-templates
        UPDATE_DISCONNECTED 1
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND cp -Rf <SOURCE_DIR>/ <BINARY_DIR>/
        COMMAND chmod -R 750 <BINARY_DIR>/.git
        COMMAND rm -r <BINARY_DIR>/.git
        COMMAND find <BINARY_DIR> -name .* -delete   # doesn't seem to work for non-empty directories
        INSTALL_COMMAND ""
)


ExternalProject_Add_StepTargets(templates update)
# Because we set UPDATE_DISCONNECTED 1 above, the footprints won't be updated unless you do a make footprints-update
