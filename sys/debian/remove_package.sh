#!/bin/bash

set -eu

readonly PACKAGE=${1-python3.9}

sudo apt-get clean
sudo apt-get autoremove --purge
sudo apt-get remove -y $PACKAGE
sudo apt-get autoremove -y