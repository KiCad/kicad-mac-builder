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
echo "Installing cmake 3.8.2 for testing"
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/eaf0d6c78c8d49ffeaa158eb307101f034944795/Formula/cmake.rb
cmake --version
echo "Installing some dependencies"
brew install cmake swig glew glm cairo boost doxygen gettext wget brewsci/science/oce bison libtool autoconf automake
