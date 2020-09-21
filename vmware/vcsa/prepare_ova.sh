#!/bin/bash

set -eu

# 1. Get iso
mount -t  nfs 192.168.145.53:/volume1/Software /mnt
cp /mnt/Software/VMware\ vSphere\ 7.0/VMware-VCSA-all-7.0.0-15952498.iso ~/
umount /mnt

# 2. Get OVA inside iso
mount -o loop VMware-VCSA-all-7.0.0-15952498.iso /mnt
cp /mnt/vcsa/VMware-vCenter-Server-Appliance-7.0.0.10100-15952498_OVF10.ova ~/