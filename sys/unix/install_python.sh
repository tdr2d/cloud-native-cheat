#!/bin/bash

set -eu

readonly VERSION="${1-3.8.5}"

# usage: sudo ./py.sh 3.12.4


# Prereq
# Rhel based
# yum install @development -y 
# yum install zlib-devel -y

# debian based
apt update
apt install build-essential zlib1g-dev libssl-dev -y


# Build python
curl -LO https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz
tar -xf Python-$VERSION.tar.xz
cd Python-$VERSION
./configure

make
make install