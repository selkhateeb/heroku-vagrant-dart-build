#!/bin/bash
# Build dart-sdk from scratch. This includes installing all dependancies
# to successfuly compile dart.

PACKAGES="subversion git-core git-svn openjdk-6-jdk build-essential \
         libc6-dev-i386 g++-multilib gcc-4.6 g++-4.6 realpath"

dpkg -s $PACKAGES > /dev/null
INSTALLED=$?

set -e # exit on first error

# Prepare machine
# https://code.google.com/p/dart/wiki/BuildDartSDKOnUbuntu10_04
if [ $INSTALLED -ne 0 ]; then
    sudo apt-get update
    sudo apt-get install -y python-software-properties
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install -y $PACKAGES
    sudo apt-get -y upgrade
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 20
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 20
    sudo update-alternatives --config gcc
    sudo update-alternatives --config g++
fi

#VERSION=trunk
VERSION=branches/1.2
BUULD_PATH=`pwd`
DART_REPO=$BUULD_PATH/dart-repo

# install chromium build scripts
if [ ! -e ./depot_tools ]; then
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
export PATH="$PATH":$BUULD_PATH/depot_tools

# Download/update source code
if [ -e $DART_REPO ]; then
    # update source
    cd $DART_REPO/dart
    git svn fetch
    git merge git-svn
else
    # Download source
    mkdir $DART_REPO; cd $DART_REPO
    gclient config https://dart.googlecode.com/svn/$VERSION/deps/all.deps
    git svn clone -rHEAD https://dart.googlecode.com/svn/$VERSION/dart dart
fi
gclient sync --force


# Build
cd $DART_REPO/dart
## release doesn't compile
#./tools/build.py -v -j 4 --arch=x64 -m release create_sdk
./tools/build.py -j4 -m release -a x64 create_sdk


# if all goes well:
# tar to /vagrant
if [ -e /vagrant/dart-sdk.tar ]; then
    rm /vagrant/dart-sdk.tar
fi
cd $DART_REPO/dart/out/ReleaseX64
tar czf /vagrant/dart-sdk.tar dart-sdk

echo "`./dart --version`"
echo "
Successfuly built Dart SDK
"
