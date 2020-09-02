#!/bin/bash

set -eu

cd /tmp
curl -LO https://releases.hashicorp.com/terraform/0.13.2/terraform_0.13.2_linux_amd64.zip
unzip /tmp/terraform_0.13.2_linux_amd64.zip
sudo mv /tmp/terraform /usr/local/bin