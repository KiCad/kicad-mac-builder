include(ExternalProject)

ExternalProject_Add(
        ngspice
        PREFIX  ngspice
        GIT_REPOSITORY git://git.code.sf.net/p/ngspice/ngspice
        GIT_TAG 99a20162d5038a328d335d11da69c9eee0549fdc
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND  ./autogen.sh
        COMMAND  ./configure --with-ngshared --enable-xspice --enable-cider --prefix=${ngspice_INSTALL_DIR}
        BUILD_COMMAND make
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND make install
)
