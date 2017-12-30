cmake_minimum_required(VERSION 3.8)
include (ExternalProject)

ExternalProject_Add(
        translations
        PREFIX  translations
        GIT_REPOSITORY ${TRANSLATIONS_URL}
        GIT_TAG ${TRANSLATIONS_TAG}
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<BINARY_DIR>/output
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
)