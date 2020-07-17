#!/bin/sh

set -euo pipefail


install_awx() {
    local tmpdir=$(mktemp -d)
    LATEST_AWX=$(curl -s https://api.github.com/repos/ansible/awx/tags |egrep name |head -1 |awk '{print $2}' |tr -d '"|,')
    echo "Installing AWS version: $LATEST_AWX"
    cd tmpdir
    curl -L -o ansible-awx-$LATEST_AWX.tar.gz https://github.com/ansible/awx/archive/$LATEST_AWX.tar.gz && \
    tar xvfz ansible-awx-$LATEST_AWX.tar.gz && rm -f ansible-awx-$LATEST_AWX.tar.gz
    cd awx-$LATEST_AWX
}


install_awx