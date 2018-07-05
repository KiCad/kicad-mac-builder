KiCad Mac Builder
=================

This is the 2017+ KiCad Mac builder and packager.  It does not yet work.  Do not use it to build or package.  It's close, though.

This supports macOS 10.11, 10.12, and 10.13.

[![Build Status](https://builder.wayneandlayne.com/buildStatus/icon?job=kicad-mac-builder-10.11-upload)](https://builder.wayneandlayne.com/job/kicad-mac-builder-10.11-upload) (master branch, all three DMGs, built from scratch on a new 10.11 VM for 10.11-10.13)

If you are looking to run KiCad on your Mac, please use the instructions at http://kicad-pcb.org/download/osx/ instead of this.  If you are looking to compile KiCad or improve KiCad packaging on MacOS, kicad-mac-packager may be able to help you.

Setup
=====
kicad-mac-builder requires a 10.11+ Mac with homebrew and at least 20G of disk space free.  The instructions assume you are capable of using the command line but they are not intended to require arcane deep knowledge.

You do not need to install anything not listed in this README. If you need to, please let me know because it is a bug in either functionality or documentation.

It may be helpful to run `brew list` before installing any dependencies.  This makes it easier to clean up the new dependencies when uninstalling kicad-mac-builder.

The instructions are split up based on macOS version.

macOS 10.12-10.13
-----------------

Please use a terminal to run the following command:

`brew install cmake swig glew glm cairo boost doxygen gettext wget brewsci/science/oce bison libtool automake autoconf`

You do not need to do any supplemental linking steps implied by the brew output.

macOS 10.11
-----------

The Homebrew OCE bottle for 10.11 is broken.  It refers to the SDK for 10.12.  You have two options, both of which are commands you run in the terminal.

You can either build it yourself with:
`brew install --build-from-source brewsci/science/oce`
or use the bottle I made and include in this repository.
`brew install -f external/oce-0.18.2.el_capitan.bottle.1.tar.gz`

Once you've done that, install the rest of the dependencies using the terminal.
`brew install cmake swig glew glm cairo boost doxygen gettext wget bison libtool automake autoconf`

You do not need to do any supplemental linking steps implied by the brew output.

Usage
=====
To get up and running the absolute fastest, use `build.py`.  It expects to be run from the directory it is in, like;

`./build.py`

It builds everything and uses "reasonable" settings.  If you want something special, check `./build.py --help`, and if that doesn't help, read the rest of this documentation.  Failing that, run `cmake` and `make` by hand.  Better documentation is definitely welcomed!

By default, dependencies are built once, and unless their build directories are cleaned out, or their source is updated, they will not be built again.  The KiCad files, like the footprints, symbols, 3D models, translations, docs, and KiCad itself, are, by default, built from origin/master of their respective repositories or re-downloaded, ensuring you have the most up-to-date KiCad. 

* `build.py --target kicad` builds KiCad and its source code dependencies, but packages nothing.  This is the same for any other CMake targets.
* `build.py --target package-kicad-nightly` creates a DMG of everything except the 3D models.
* `build.py --target package-extras` creates a DMG of the 3D models.
* `build.py --target package-kicad-unified` creates a DMG of everything.
* `build.py` create all the DMGs.

During the build, some DMGs may be mounted and Finder may open windows while the script runs.  Unmounting or ejecting the DMGs while the script runs is likely to damage the output DMG.

The output DMGs from `build.py` go into build/dmgs.

KiCad Mac Builder does not install KiCad onto your Mac or modify your currently installed KiCad.

Building inside a VM
====================
It has been historically very difficult to build and package KiCad on macOS.  Even if the source builds fine, getting the environment setup has been quite difficult.  In order to help both developers who want to use kicad-mac-builder to quickly develop and test on macOS, and to make sure that new developers can follow the instructions and quickly and easily get a working setup, I have some Jenkinsfiles setup in ci/.  These Jenkinsfiles use Vagrant and a blank macOS virtual machine (https://github.com/timsutton/osx-vm-templates).  These machines are freshly installed machines from the macOS install media with security patches and the XCode command line tools installed.  Starting from that blank machine and a checkout of this repository, the scripts in ci/ are used to install brew and any dependencies, and then build and package KiCad.  When its finished, the machine is deleted.  This happens at least once a day.

This is intended to increase reproducibility and reduce the likelihood of undocumented steps and stale documentation.  It does take more resources and is slower, so it is not expected to be the way most developers interact with kicad-mac-builder.

Please note, that as of early 2018, to create a 10.13 VM with the osx-vm-templates project, you must start with a 10.12 VM and upgrade it.

Testing KiCad Patches
=====================
Any patches inside kicad-mac-builder/patches/kicad/ are applied via git-am, per kicad-mac-builder/kicad.cmake.  This helps make it easy to test patches that may affect KiCad macOS packaging.

Issues
======
In early 2018, I'm noticing that sometimes wxPython doesn't download properly from Sourceforge, so I've included a mirror in this repository.

In May 2018, the OCE bottle for 10.11 refers to the 10.12 SDK internally.  It requires the full XCode to install, not just the CLI tools.  I have included a bottle in case you are doing this on a headless machine without XCode.

In May 2018, the KiCad 10.11 build machine has an older version of CMake installed.  The included GetPrequisites and BundleUtilties do not work with what we are doing with the packaging.  I included the version from 3.10 using a KiCad patch.  As soon as that machine is upgraded, we should add a minimum CMake version and remove that patch.

Known Errors
============
Unfortunately, as of July 2018, there are messages that pop up during build that say error that are not problems.  There is work underway to reduce these to a minimum.

These include, but are not limited to:

```
==> default: Traceback (most recent call last):
==> default:   File "<string>", line 1, in <module>
==> default: ImportError: No module named wx
```

```
error: /Library/Developer/CommandLineTools/usr/bin/install_name_tool: for: libGLEW.2.1.dylib (for architecture x86_64) option "-add_rpath @loader_path/../.." would duplicate path, file already has LC_RPATH for: @loader_path/../..
```

with a variety of paths...


Making KiCad Mods
=================
When doing some types of work, it can be helpful to have these scripts build KiCad from a location on your computer, rather than the integrated checkout via git.  This can be easily done by removing the 2 GIT_* lines from kicad.cmake, and replace them SOURCE_DIR.

Making changes to KiCad-mac-builder
===================================

New Dependencies
----------------
You cannot assume brew uses default paths, as at least one of the build machines has multiple brew installations.  See `build.py` for examples.

Make sure you add any new dependencies to this README, as well as to the ci/ scripts.  If you don't, the builds from a clean VM will certainly fail.

Linting
-------
To prescreen your changes for style issues, install shellcheck and cmakelint and run the following from the same directory as this README:

`find . -path ./build -prune -o -name \*.sh -exec shellcheck {} \;`

`cmakelint --filter=-linelength,-readability/wonkycase kicad-mac-builder/CMakeLists.txt`

`find . -path ./build -prune -o -name \*.cmake -exec cmakelint --filter=-linelength,-readability/wonkycase {} \;`

Test Procedure
==============
Before big releases, we should check to make sure all the component pieces work.

Remove the build/ directory, and run `build.py`.  Then, rerun `build.py`, to make sure that everything works with both new and incremental builds.

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
