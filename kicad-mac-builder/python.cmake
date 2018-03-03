include (ExternalProject)

ExternalProject_Add(
        python
        PREFIX  python
        URL ${PYTHON_URL}
        URL_HASH SHA1=${PYTHON_SHA1}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND MACOSX_DEPLOYMENT_TARGET=${MACOS_MIN_VERSION} ./configure
                    --prefix=${PYTHON_INSTALL_DIR}
                    --enable-shared
        BUILD_COMMAND make
        BUILD_IN_SOURCE 1
)
