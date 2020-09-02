#!/bin/sh

set -eu

cd /tmp
curl -LO https://releases.hashicorp.com/packer/1.6.2/packer_1.6.2_linux_amd64.zip && \
unzip packer_1.6.2_linux_amd64.zip && \
sudo mv /tmp/packer /usr/local/bin && \
rm -rf packer_1.6.2_linux_amd64.zip