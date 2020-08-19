#!/bin/sh

set -euo pipefail

#yum install nfs-utils -y

NFS_SERVER=${1:-192.168.95.110}


systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

# mount  -t nfs -o rw,noatime $NFS_SERVER:/public /nfs
mkdir /nfs
mount -t nfs -o rw,nosuid,nfsvers=3,nolock $NFS_SERVER:/public /nfs
# mount $NFS_SERVER:/public /mnt/nfs  # mount /public of the nfs server into /mnt of the client server


# Unmount 
# umount /nfs