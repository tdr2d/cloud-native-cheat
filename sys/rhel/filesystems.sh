## 0. Infos
lsblk       # List current root disk capacity
fdisk -l    # show partitions
df -hT      # List all filesystems, their type and mount point
xfs_info /dev/mapper/centos-root # See xfs block infos


## 1. Scan disk updates
echo 1 > /sys/class/scsi_device/0\:0\:0\:0/device/rescan # rescan the scsi bus if you increased the disk size
ls  /sys/class/scsi_host/                       # or rescan the host to detect the new scsi bus
echo "- - -" > /sys/class/scsi_host/host0/scan  # then if your host device is called host0
fdisk -l # check the new disk size


## Resize existing partition
printf "d\n2\nn\np\n2\nw\n" > /tmp/delete_part_sda2 && fdisk /dev/sda < /tmp/delete_part_sda2 # delete /dev/sda2 partition
partprobe # While on-disk partition table has been updated, observe that on-memory kernel partition table has not
partx -u /dev/vda # Execute partx (provided by util-linux package to update the in-memory kernel partition table from the on-disk partition table
cat /proc/partitions | grep sd # Verify that in-memory kernel partition table has been updated with the new size:
pvresize /dev/sda2 # Update pvs and lv


## Create new partition on disk
printf "n\np\n3\n\n\nt\n3\n8e\nw\n"  > /tmp/answer && fdisk /dev/sda < /tmp/answer # Create new primary partition /dev/sda3 of type Linux LVM (8e) on /dev/sda
partprobe -s || partx -v -a /dev/sda # scan the newly added partition
fdisk -l # check the new partition


## Extend Logical Volumes
pvcreate /dev/sda3                   # create physical volume
vgs                                  # list volume group
vgextend centos /dev/sda3            # add the physical volume to the centos vg
pvs                                  # check physical volume associated vg
lvextend /dev/centos/root /dev/sda3  # extend Logical Volume 

resize2fs /dev/centos/root || xfs_growfs /dev/centos/root # for xfs fs type
df -hT # check logical volumes size
