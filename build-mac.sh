#!/bin/bash -ev

#exports environment variables needed for build tool paths
. ./setenv.sh

#clears and redownloads the libsodium submodule
./submodule-update.sh

#builds libsodium for the host operating system
./build-libsodium-host.sh

cp ./libsodium/src/libsodium/include/sodium/crypto_vrf*.h ./libsodium/libsodium-host/include/sodium/

#needed for mac osx
C_INCLUDE_PATH="${JAVA_HOME}/include:${JAVA_HOME}/include/linux:${JAVA_HOME}/include/darwin:/System/Library/Frameworks/JavaVM.framework/Headers"
export C_INCLUDE_PATH

gradle tasks --all
gradle generateSWIGsource --full-stacktrace
gradle build --full-stacktrace
#shorten build time by excluding tasks
#gradle compileReleaseSources -x compileNative_android-westmere -x compileNative_android-mips64r6 -x compileNative_android-mips32 -x compileNative_android-armv6  --full-stacktrace
#gradle compileNative_android-armv6 compileNative_android-armv7-a compileNative_host
#gradle compileNative_android-armv7-a compileNative_host

#not able to run on travis
#cp: /usr/lib/libsodium.dylib: Operation not permitted
#sudo cp ./libsodium/libsodium-host/lib/libsodium.dylib /usr/lib

#pushd jni
#./jnilib.sh
#popd

#mvn -q clean install
#./singleTest.sh


#./build-kaliumjni.sh
#./build-libsodiumjni.sh
