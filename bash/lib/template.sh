#!/bin/bash

set -euo pipefail

# usage() { echo "Usage: ./template.sh arg2 arg2"; }
# if [ $# -ne 2 ]; then usage; exit 1; fi
# ARG1="$1"
# ARG2="$2"
# [ ! -e my_file ] && yum install dnsmasq-y
# [ ! $(command -v curl) ] && yum install curl -y

# eval a file, replace ${variables} defined in bash
template() {
    [ -e $1 ] && eval "cat <<EOF
$(<$1)
EOF" 2> /dev/null
}

