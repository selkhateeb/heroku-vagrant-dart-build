#!/bin/bash
# Build dart-sdk from scratch. This includes installing all dependancies
# to successfuly compile dart.

set -e # exit on first error

DART_REPO=`pwd`/dart-repo

if [ ! "`dpkg -s subversion`" ]; then
    sudo apt-get update
    sudo apt-get install subversion git-core git-svn python-software-properties
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java6-installer
fi

# install gclient
if [ ! -e ./depot_tools ]; then
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi
export PATH="$PATH":`pwd`/depot_tools


# Prepare machine
# https://code.google.com/p/dart/wiki/PreparingYourMachine
if [ ! -e ./install-build-deps.sh ]; then
    wget http://src.chromium.org/svn/trunk/src/build/install-build-deps.sh
    chmod u+x install-build-deps.sh
    ./install-build-deps.sh --no-chromeos-fonts
fi


# Download/update source
if [ -e $DART_REPO ]; then
    # update source
    cd $DART_REPO/dart
    git svn fetch
    git merge git-svn
else 
    # Download source
    mkdir $DART_REPO; cd $DART_REPO
    gclient config https://dart.googlecode.com/svn/trunk/deps/all.deps
    git svn clone -rHEAD https://dart.googlecode.com/svn/trunk/dart dart
fi
gclient sync


# Build
cd $DART_REPO/dart
## release doesn't compile
#./tools/build.py -v -j 4 --arch=x64 -m release create_sdk
./tools/build.py -v -j 4 --arch=x64 create_sdk

# if all goes well:
# tar to /vagrant
if [ -e /vagrant/dart-sdk.tar ]; then
    rm /vagrant/dart-sdk.tar
fi
cd $DART_REPO/dart/out/DebugX64
tar czf /vagrant/dart-sdk.tar dart-sdk

echo "
Successfuly built Dart SDK
"
