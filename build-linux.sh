#!/bin/bash -ev

#exports environment variables needed for build tool paths
. ./setenv.sh

#clears and redownloads the libsodium submodule
./submodule-update.sh

#builds libsodium for the host operating system
./build-libsodium-host.sh

cp ./libsodium/src/libsodium/include/sodium/crypto_vrf*.h ./libsodium/libsodium-host/include/sodium/

#generates the swig bindings
gradle generateSWIGsource --full-stacktrace
#performs the android ndk libsodium build
gradle build --full-stacktrace

#host building of jni wrapper around libsodium shared library (linux and mac)
pushd jni
./jnilib.sh
popd

#copies the libsodium shared library to the host lib path in order to be able to use host libsodium library (had errors loading library from custom location)
sudo cp ./libsodium/libsodium-host/lib/libsodium.so /usr/lib
#host libsodium api build
mvn -q clean install
#test that the host libsodium works
./singleTest.sh

