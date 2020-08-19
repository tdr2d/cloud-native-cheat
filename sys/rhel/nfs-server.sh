#!/bin/sh

set -euo pipefail

yum install nfs-utils nfs-utils-lib -y

mkdir /public
touch /public/nfs1 /public/nfs2 /public/nfs3

cat << EOF > /etc/exports
/public *(rw,sync,no_root_squash)
EOF
exportfs -r

systemctl start nfs # port 111
systemctl stop firewalld