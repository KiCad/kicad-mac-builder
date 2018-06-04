set( DOCS_OUTPUT_DIR ${CMAKE_BINARY_DIR}/docs/help )

ExternalProject_Add(
        docs
        PREFIX  docs
        DOWNLOAD_DIR     ${CMAKE_BINARY_DIR}/docs/src
        DOWNLOAD_COMMAND ${BIN_DIR}/download-docs.sh <INSTALL_DIR>
        UPDATE_COMMAND   ${BIN_DIR}/download-docs.sh <INSTALL_DIR>
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
)
