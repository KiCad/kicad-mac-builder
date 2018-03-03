include (ExternalProject)

ExternalProject_Add(
        wxwidgets
        PREFIX  wxwidgets
        GIT_REPOSITORY https://github.com/KiCad/wxWidgets.git
        GIT_TAG   kicad/macos-wx-3.0
        UPDATE_DISCONNECTED 1
        CONFIGURE_COMMAND   CPPFLAGS=-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=1 MAC_OS_X_VERSION_MIN_REQUIRED=${MACOS_MIN_VERSION} ./configure
                            --prefix=${wxwidgets_INSTALL_DIR}
                            --with-opengl
                            --enable-aui
                            --enable-utf8
                            --enable-html
                            --enable-stl
                            --disable-mediactrl
                            --with-libjpeg=builtin
                            --with-libpng=builtin
                            --with-regex=builtin
                            --with-libtiff=builtin
                            --with-zlib=builtin
                            --with-expat=builtin
                            --without-liblzma
                            --with-macosx-version-min=${MACOS_MIN_VERSION}
                            CC=clang
                            CXX=clang++
        BUILD_COMMAND make
        BUILD_IN_SOURCE 1
)


ExternalProject_Add_StepTargets(wxwidgets update)
# Because we set UPDATE_DISCONNECTED 1 above, wxwidgets source won't be updated unless you do a make wxwidgets-update


set(wxpython_ENVIRONMENT_VARS UNICODE=1
        WXPORT=osx_cocoa
        WX_CONFIG=${wxwidgets_INSTALL_DIR}/bin/wx-config
        BUILD_BASE=${CMAKE_BINARY_DIR}/wxwidgets/src/wxwidgets
        )

ExternalProject_Add(
        wxpython
        DEPENDS python
        DEPENDS wxwidgets
        URL ${WXPYTHON_URL}
        URL_HASH SHA1=${WXPYTHON_SHA1}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        BUILD_IN_SOURCE     1
        CONFIGURE_COMMAND ""
        BUILD_COMMAND cd wxPython && MAC_OS_X_VERSION_MIN_REQUIRED=${MACOS_MIN_VERSION} python2.7 setup.py build_ext ${wxpython_ENVIRONMENT_VARS}
        INSTALL_COMMAND cd wxPython && MAC_OS_X_VERSION_MIN_REQUIRED=${MACOS_MIN_VERSION} python2.7 setup.py install --prefix=${wxwidgets_INSTALL_DIR} ${wxpython_ENVIRONMENT_VARS}
        BUILD_IN_SOURCE 1
)

#TODO change build command to happen in wxpython directory
