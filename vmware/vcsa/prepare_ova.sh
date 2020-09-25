#!/bin/bash

set -eu

# 1. Get iso
mount -t  nfs 192.168.145.53:/volume1/Software /mnt
cp /mnt/Software/VMware\ vSphere\ 7.0/VMware-VCSA-all-7.0.0-15952498.iso ~/
umount /mnt

# 2. Get OVA inside iso
mount -o loop VMware-VCSA-all-7.0.0-15952498.iso /mnt
mkdir -p ~/vcsa7
cp /mnt/vcsa/VMware-vCenter-Server-Appliance-7.0.0.10100-15952498_OVF10.ova ~/vcsa7/
umount /mnt
tar -xvf  ~/vcsa7/VMware-vCenter-Server-Appliance-7.0.0.10100-15952498_OVF10.ova -C ~/vcsa7

# 3. Build Template vm
mv ~/vcsa /var/www/html # expose ova to http server
chown -R apache:apache /var/www/html/vcsa7/
restorecon -r /var/www/html/vcsa7/ # selinux
echo "http://$(hostname -I | awk '{print $1}')/vcsa7/VMware-vCenter-Server-Appliance-7.0.0.10100-15952498_OVF10.ova"

# Create template vm from ova
# leave all properties blank
