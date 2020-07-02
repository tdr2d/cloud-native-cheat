#!/bin/bash

set -euo pipefail

## Usage: ./playbook.sh geerlingguy.docker 192.168.8.212 root

playbook() {
    local play=${1:-geerlingguy.docker}
    local ip=${2:-localhost}
    local user=${3:-root}
    local dir=$(mktemp -d /tmp/adhoc.XXXX)
    trap "rm -rf ${dir}" SIGINT SIGTERM EXIT
    cat << EOF > ${dir}/play.yml
---
- hosts: all
  remote_user: root
  tasks:
  - include_role: name=${play}
EOF
    ansible-playbook -i ${ip}, ${dir}/play.yml
}

playbook ${1:-geerlingguy.docker} ${2:-192.168.8.212} ${3:-root}