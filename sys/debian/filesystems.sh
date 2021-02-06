#!/usr/bin/bash

FS=${1-'/data'}
DISK=${2-'/dev/sdb'}

# format partition
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard ${DISK}
sudo mkdir -p ${FS}
sudo mount -o discard,defaults ${DISK} ${FS}
sudo chown -R $USER ${FS}   # change owner
sudo chmod -R a+w ${FS}     # write partition


# Automount Disk On Reboot
sudo cp /etc/fstab /etc/fstab.backup$(date --iso-8601=seconds)
UUID=$(sudo blkid -s UUID -o value $DISK)
echo "UUID=${UUID} ${FS} ext4 discard,defaults,nofail 0 2" | sudo tee -a /etc/fstab

# Checks
sudo df -h
sudo blkid -s UUID -o value /dev/sdb # check
sudo cat /etc/fstab # check