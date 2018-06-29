KiCad Mac Builder
=================

This is the 2017+ KiCad Mac builder and packager.  It does not yet work.  Do not use it to build or package.  It's close, though.

This supports macOS 10.11, 10.12, and 10.13.

[![Build Status](https://builder.wayneandlayne.com/buildStatus/icon?job=kicad-mac-builder-10.11-upload)](https://builder.wayneandlayne.com/job/kicad-mac-builder-10.11-upload) (master branch, all three DMGs, built from scratch on a new 10.11 VM for 10.11-10.13)

Setup
=====
10.12-10.13
-----------

`brew install cmake swig glew glm cairo boost doxygen gettext wget brewsci/science/oce bison libtool automake autoconf`

10.11
-----
The Homebrew OCE bottle for 10.11 is broken.  It refers to 10.12's SDK.  You can either build it yourself with:
`brew install --build-from-source brewsci/science/oce`
or use the bottle I made and include in this repository.
`brew install -f external/oce-0.18.2.el_capitan.bottle.1.tar.gz`

Once you've done that, install the rest of the dependencies.
`brew install cmake swig glew glm cairo boost doxygen gettext wget bison libtool automake autoconf`

Building by hand
================
To get up and running the absolute fastest, just use `build.sh`.  However, it builds everything and uses "reasonable" settings.  If you want something special, for now at least, run `cmake` and `make` by hand.  Better documentation is definitely welcomed, but for now, you can look at `build.sh` for reference.

* `build.sh` create all the DMGs.
* `build.sh kicad` just builds KiCad, but packages nothing.  This is the same for any other CMake targets.
* `build.sh package-kicad-nightly` creates a DMG of everything except the 3D models in `build/dmg`.
* `build.sh package-extras` creates a DMG of the 3D models in `build/dmg`.
* `build.sh package-kicad-unified` creates a DMG of everything in `build/dmg`.

There is only one special parameter for `build.sh`.  By default, it finds the number of cores in your system and passes that to `make` with `-j`.  If the first argument to `build.sh` is `--NUM_CORES=2`, where 2 can be replaced with a number, `build.sh` will pass that number to `make` with `-j`.  Any other arguments are passed through to `make`.

Building inside a VM
====================
There can be value in building inside a VM.  This can help increase isolation and repeatability, by reducing the chances that something "sticks around" between builds, and helps reduce the chances of undocumented steps.  However, it can be slower and take more resources.

I do this, however, to make sure that people can build using 10.11, 10.12, and 10.13.  To do this, setup a macOS Vagrant machine.  I use https://github.com/timsutton/osx-vm-templates.  Please note, that as of early 2018, to create a 10.13 VM you must start with a 10.12 VM and upgrade it.

There is an example Vagrantfile and scripts in `vagrant/`.

Testing KiCad Patches
=====================
Any patches inside kicad-mac-builder/patches/kicad/ are applied via git-am, per kicad-mac-builder/kicad.cmake.  This helps make it easy to test patches that may affect KiCad macOS packaging.

New Dependencies
================
You cannot assume brew uses default paths, as at least one of the build machines has multiple brew installations.  See `build.sh` for examples.

Make sure you add any new dependencies to this README, as well as to the ci/ scripts.

Issues
======
In early 2018, I'm noticing that sometimes wxPython doesn't download properly from Sourceforge, so I've included a mirror in this repository.

In May 2018, the OCE bottle for 10.11 refers to the 10.12 SDK internally.  It requires the full XCode to install, not just the CLI tools.  I have included a bottle in case you are doing this on a headless machine without XCode.

In May 2018, the KiCad 10.11 build machine has an older version of CMake installed.  The included GetPrequisites and BundleUtilties do not work with what we are doing with the packaging.  I included the version from 3.10 using a KiCad patch.  As soon as that machine is upgraded, we should add a minimum CMake version and remove that patch.

Linting
=======
To prescreen your changes for style issues, install shellcheck and cmakelint and run the following from the same directory as this README:

`find . -path ./build -prune -o -name \*.sh -exec shellcheck {} \;`

`cmakelint --filter=-linelength,-readability/wonkycase kicad-mac-builder/CMakeLists.txt`

`find . -path ./build -prune -o -name \*.cmake -exec cmakelint --filter=-linelength,-readability/wonkycase {} \;`

Making KiCad Mods
=================
When doing some types of work, it can be helpful to have these scripts build KiCad from a location on your computer, rather than the integrated checkout via git.  This can be easily done by removing the 2 GIT_* lines from kicad.cmake, and replace them SOURCE_DIR.

Test Procedure
==============
Before big releases, we should check to make sure all the component pieces work.

Remove the build/ directory, and run `build.sh`.  Then, rerun `build.sh`, to make sure that everything works with both new and incremental builds.

Basics
------
* Open up KiCad.app, and then open up each of the applications like pcbnew and the calculator.
* Open up each of the apps in standalone mode.

Templates
---------
* Open up KiCad.app, and click File -> New -> Project from Template.  You should see a new window pop up with options like STM32 and Raspberry Pi.  Select one, and click OK.  It will ask you where to save.  Make a new directory somewhere, and select it.  You should see no errors.

Python
------
* Open up pcbnew.app, and open up the Python scripting console.  Type `import pcbnew` and press enter.  It shouldn't show an error.  Verify that the build date of Python is the same as the build date of the package.
* Open up KiCad.app, and open up the Python scripting console. Type `import pcbnew` and press enter.  It shouldn't show an error.  Verify that the build date of Pytohn is the same as the build date of the package.
* Open up the terminal, and run `kicad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python`.  It shouldn't show an error.  Verify that the build date of Python is the same as the build date of the package.
* Open up the terminal, and run `cd kicad.app/Contents/Frameworks/python/site-packages/; ../../Python.framework/Versions/Current/bin/python -m pcbnew`.  It shouldn't show an error.

Footprint Wizards
-----------------
* Open up pcbnew.app, and open up the footprint editor. Click the "New Footprint Using Footprint Wizard" button. Click the "Select Wizard" button.  Select BGA.  Click OK.  Click the "Export footprint to editor" button.  You should see a footprint on the editor screen, and you should see no errors.
* Open up KiCad.app, and open up the footprint editor. Click the "New Footprint Using Footprint Wizard" button. Click the "Select Wizard" button.  Select BGA.  Click OK.  Click the "Export footprint to editor" button.  You should see a footprint on the editor screen, and you should see no errors.

Localization
------------
* Open up KiCad.app, and change the language via Preferences -> Language.  You should see the text in the menubars change.

3D Models
---------
* Open up KiCad.app, and open up demos/pic_programmer/pic_programmer.pro.  Open up pcbnew.  Click View->3D Viewer.  A new window opens.  It should show a PCB with mostly populated components, including LEDs, sockets, resistors, and capacitors.  At least one connector appears to be missing.
* Open up pcbnew.app, and open up demos/pic_programmer/pic_programmer.pro.  Click View->3D Viewer.  A new window opens.  It should show a PCB with mostly populated components, including LEDs, sockets, resistors, and capacitors.  At least one connector appears to be missing.

OCE
---
* Open up KiCad.app, and open up demos/pic_programmer/pic_programmer.pro.  Open up pcbnew.  Click File->Export->STEP.  Click OK on the Export Step dialog.  The output should print "Info: STEP file has been created successfully.".  Currently, I see a lot warnings but these appear to be related to models not being set up.
* Open up pcbnew.app, and open up demos/pic_programmer/pic_programmer.kicad_pcb.  Click File->Export->STEP.  Click OK on the Export Step dialog.  The output should print "Info: STEP file has been created successfully.".  Currently, I see a lot warnings but these appear to be related to models not being set up.
  
Help
----
* Open up KiCad.app, and open up the help documents via Help -> KiCad Manual and Help -> Getting Started in KiCad.  You should see a browser open with the documentation.
* Open up KiCad.app, and change the languages to something not English via Preferences -> Language.  Then open up the manual via Help -> KiCad Manual.  You should see a browser open with the documentation in the matching language.

Tips
----
When debugging dylib stuff, the environment vaiables DYLD_PRINT_LIBRARIES and DYLD_PRINT_LIBRARIES_POST_LAUNCH are helpful.  For instance:

`DYLD_PRINT_LIBRARIES=YES DYLD_PRINT_LIBRARIES_POST_LAUNCH=YES  /Users/wolf/KiCad/kicad.app/Contents/Applications/pcbnew.app/Contents/MacOS/pcbnew`
