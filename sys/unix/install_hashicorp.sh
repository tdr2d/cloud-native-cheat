#!/bin/bash

set -eu

# Usage ./install_hashicorp.sh terraform
# arg1: terraform, packer

readonly system="$(uname -s | awk '{print tolower($0)}')"
readonly binary=$1

cd /tmp
if [ "$1" = "terraform" ]; then
  readonly VERSION="0.13.2"
  curl -LO https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${system}_amd64.zip
  unzip /tmp/terraform_${VERSION}_linux_amd64.zip
  sudo mv /tmp/terraform /usr/local/bin
  rm -f terraform_${VERSION}_linux_amd64.zip
elif [ "$1" = "packer" ]; then
  readonly VERSION="1.6.2"
  curl -LO https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_${system}_amd64.zip && \
  unzip packer_${VERSION}_linux_amd64.zip && \
  sudo mv /tmp/packer /usr/local/bin && \
  rm -r packer_${VERSION}_linux_amd64.zip
fi



