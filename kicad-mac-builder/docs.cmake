set( DOCS_OUTPUT_DIR ${CMAKE_BINARY_DIR}/docs/help )

ExternalProject_Add(
        docs
        PREFIX  docs
        DOWNLOAD_COMMAND mkdir -p ${CMAKE_BINARY_DIR}/docs/src
        UPDATE_COMMAND curl ${DOCS_TARBALL_URL} -o ${CMAKE_BINARY_DIR}/docs/src/docs.tar.gz
        CONFIGURE_COMMAND ""
        BUILD_COMMAND tar -xf ${CMAKE_BINARY_DIR}/docs/src/docs.tar.gz -C <INSTALL_DIR> --strip-components=1
        INSTALL_COMMAND ""
)
