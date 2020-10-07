#!/bin/bash

set -eu

readonly tmpdir="/tmp/templates/rhel"
mkdir -p $tmpdir

ansible localhost -m template -a "src=packer.json dest=${tmpdir}/packer.json" -e @../../vars.yml \
    -e template_ip=192.168.95.242 \
    -e template_hostname=t-rhel-7-8.adlere.priv \
    -e kernet_ssh_pass=$KERNET_SSH_PASS \
    -e work_dir=$tmpdir

ansible localhost -m template -a "src=ks.cfg dest=${tmpdir}/ks.cfg" -e @../../vars.yml \
    -e template_ip=192.168.95.242 \
    -e template_hostname=t-rhel-7-8.adlere.priv \
    -e kernet_ssh_pass=$KERNET_SSH_PASS \
    -e work_dir=$tmpdir

cd $tmpdir && packer build packer.json
rm -rf $tmpdir