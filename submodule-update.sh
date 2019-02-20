#!/bin/bash -ev

set -ev

. ./setenv.sh

rm -rf libsodium

git submodule init
git submodule sync
#git submodule update --remote --merge
git submodule update

pushd libsodium

git fetch && git checkout draft-irtf-cfrg-vrf-03
git reset --hard origin/draft-irtf-cfrg-vrf-03
git pull
popd
