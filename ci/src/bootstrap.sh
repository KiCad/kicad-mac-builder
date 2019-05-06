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
#echo "Installing cmake 3.6.2 for testing"
#brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/eaf0d6c78c8d49ffeaa158eb307101f034944795/Formula/cmake.rb
#cmake --version
# version pinning glm
echo "Installing glm 0.9.9.2"
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/9ce61eaa2776d0ab011e0559a86afff588f6eccb/Formula/glm.rb
# version pinning boost
echo "Installing boost"
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/b4de2e1ce084ec249ca61c3eff6f96617e38c081/Formula/boost.rb
echo "Instaling swig"
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/5cf8527323475aec3299180aa4f4f63c09ddc99a/Formula/swig.rb
echo "Installing some dependencies"
brew install glew cairo doxygen gettext wget bison libtool autoconf automake cmake
brew install -f /vagrant/external/oce*tar.gz

