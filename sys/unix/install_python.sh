#!/bin/bash

set -eu

readonly VERSION="${1-3.8.5}"

# usage: sudo ./py.sh 3.12.4


# Prereq
yum install @development -y || apt install build-essential -y
yum install zlib-devel -y   || apt-get install zlib1g-dev libssl-dev -y

# Build python
curl -LO https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz
tar -xf Python-$VERSION.tar.xz
cd Python-$VERSION
./configure

make
make install