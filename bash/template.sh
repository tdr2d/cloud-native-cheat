#!/bin/bash
set -euo pipefail
set -x # keep for debug only

## Usage ./template.sh foo [args]
##
## help: show this helps
help() { cat $0 | fgrep -h "##" | fgrep -v "fgrep" | column -s: -t | sed -e 's/## //' | sed -e 's/##//'; }


## checks: check local system
checks() {
  [ ! -e my_file ] && yum install dnsmasq-y
  [ ! $(command -v curl) ] && yum install curl -y
}


## foo: foo
foo(){
  echo "$@"
}

printerr() { >&2 echo "$@"; }

if [ "$#" -lt 1 ]; then help; else ${*}; fi