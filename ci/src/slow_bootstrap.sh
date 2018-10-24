#!/bin/bash
set -x
set -e

for _ in 1 2 3; do
  if ! command -v brew >/dev/null; then
    echo "Installing Homebrew ..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null || echo "failed."
  else
    echo "Homebrew installed."
    break
  fi
done

PATH=$PATH:/usr/local/bin
export HOMEBREW_NO_ANALYTICS=1
echo "Installing cmake 3.6.2 for testing"
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/eaf0d6c78c8d49ffeaa158eb307101f034944795/Formula/cmake.rb
cmake --version
echo "Installing some dependencies"
OUT=$(brew install --build-bottle swig glew glm cairo boost doxygen gettext wget bison libtool autoconf automake)
if echo $OUT | grep 'Installing dependencies'; then
    echo "In order to force all the brew dependencies to be built for older macOS versions, we build bottles.  However, dependencies of what we tell brew to install are not forced to be built.  This means we need to resolve the dependencies ourselves.  Dependency detected... exiting."
    exit 1
fi
brew install -f /vagrant/external/oce*tar.gz
