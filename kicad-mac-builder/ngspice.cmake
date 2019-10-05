include(ExternalProject)

ExternalProject_Add(
        ngspice
        PREFIX  ngspice
        GIT_REPOSITORY git://git.code.sf.net/p/ngspice/ngspice
        GIT_TAG master
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND  ./autogen.sh
        COMMAND  ./configure --prefix=${ngspice_INSTALL_DIR} --with-ngshared --enable-xspice --enable-cider --disable-debug
        BUILD_COMMAND ${MAKE}
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND make install
)
