#!/bin/bash
set -eo pipefail

# usage: sudo ./py.sh
# usage: sudo ./py.sh 3.12.5
PY_VERSION="${1}"

# get latest version
if [ -z "${PY_VERSION}" ]; then
PY_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/actions/python-versions/releases/latest | grep -o '[0-9]\.[0-9]*\.[0-9]*')
echo "Latest version is: ${PY_VERSION}"
fi

# Prereq # Rhel based # yum install @development zlib-devel -y 
# debian based
apt update
apt install build-essential zlib1g-dev libssl-dev -y


# Build python
cd /tmp
curl -LO https://www.python.org/ftp/python/$PY_VERSION/Python-$PY_VERSION.tar.xz
tar -xf Python-$PY_VERSION.tar.xz
cd Python-$PY_VERSION
./configure --enable-optimizations
make && make install

# Clean
cd ..
rm Python-$PY_VERSION.tar.xz
rm -rf Python-$PY_VERSION