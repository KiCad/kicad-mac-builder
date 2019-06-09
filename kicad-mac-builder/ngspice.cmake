include(ExternalProject)

ExternalProject_Add(
        ngspice
        PREFIX  ngspice
        GIT_REPOSITORY git://git.code.sf.net/p/ngspice/ngspice
        GIT_TAG ngspice-30-2
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND  ./autogen.sh
        COMMAND  ./configure --with-ngshared --enable-xspice --enable-cider --prefix=${ngspice_INSTALL_DIR}
        BUILD_COMMAND ${MAKE}
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND make install
)
