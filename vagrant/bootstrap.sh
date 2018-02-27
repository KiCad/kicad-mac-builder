#!/bin/bash
set -x
set -e

if ! command -v brew >/dev/null; then
  echo "Installing Homebrew ..."
  sleep 5
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
else
  echo "Homebrew already installed. Skipping."
fi


PATH=$PATH:/usr/local/bin
export HOMEBREW_NO_ANALYTICS=1

echo "Installing some dependencies"
brew install cmake swig glew glm cairo boost doxygen gettext wget
