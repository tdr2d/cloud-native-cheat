#!/bin/sh

PY_VERSION="${1-3.7}"

apt remove python -y
apt remove python3 -y

add-apt-repository ppa:deadsnakes/ppa -y
apt-get update -y

rm -rf /usr/bin/python*
apt-get install python${PY_VERSION} python3-pip -y
cp /usr/bin/python${PY_VERSION} /usr/bin/python

ln -s /usr/bin/python3 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip