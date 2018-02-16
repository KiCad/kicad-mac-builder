KiCad Mac Builder
=================

This is the 2017+ KiCad Mac builder and packager.  It does not yet work.  Do not use it to build or package.

It's close, though.

When I run on MacOS, I need to do the following:

`brew install cmake swig glew glm cairo boost doxygen gettext wget`

and then I need to

```
export PATH=$PATH:/usr/local/opt/gettext/bin
mkdir -p build
cd build
cmake ../
make
```



TODO:
* Setup "stable" mode, where it produces stable release builds.
* Setup "build-only" mode, where it doesn't package.
* Review how footprints/symbols/templates/3D models/demos/scripts are packaged, and make sure it works.
* Test on 10.11.
* Work on *this* README, adding usage docs for all the applicable use cases.
* Work on the main DMG README and logs.
* Work on the extras DMG README and logs.
* Figure out if we need to include library tables.
* Setup on Wayne and Layne Jenkins with a 10.11 VM.
* Setup output name and path for package-kicad and package-extras

Future things:
* Investigate bringing KiCad source in via a submodule or something.
* Investigate using CPack.
* Review for consistent style.
