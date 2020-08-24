#!/bin/sh

set -euo pipefail

ARG1="$1"
ARG2="$2"

#usage: ./template.sh arg2 arg2

[ ! -e my_file ] && yum install dnsmasq-y
[ ! $(command -v curl) ] && yum install curl -y