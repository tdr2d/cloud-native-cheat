# NFS solutions on Linux
**[nfs-ganesha](https://github.com/nfs-ganesha/nfs-ganesha/wiki/Setup)** comes as the first NFS server open-source solution, however is not completely mature according to a 2012 post from the nfs-kernel-server maintainer.
It does not provide its own clustering support, but HA can be achieved using Linux HA, via GlusterFS, or CephFS.
It supports NFSv3 and NFSv4.

**[unfs3](https://github.com/unfs3/unfs3)** is another interesting project. It supports NFSv3 only.
HA mode is supported via the AFS network filesystem.

**nfs-kernel-server aka nfsd** Is de default NFS solution for linux. Is developped within the linux kernel, so in the linux git repository. It supports NFSv3 and NFSv4.
Is not well documented on the [kernel.org](https://docs.kernel.org/filesystems/nfs/index.html) website.
We must visit distribution specific linux OS websites  (like ubuntu, debian or FreeBSD) to get better user guides.
There is no simple way to scale-out or replicate nfs server, thus this solution is suitable for few terrabytes of data.

**[ZFS](https://openzfs.github.io/openzfs-docs/) (Zettabyte File System)**. A file system offering the same features as Btrfs and more (compression, encryption, de-duplication, replication). Is extremely stable and well-tested. Its main drawback is that it's not integrated into the Linux kernel due to a silly licensing issue.

## Enterprise NFS solutions
- Netapp ONTAP Select
- Scality RING file storage
- [Dell PowerPath](https://www.dell.com/support/kbdoc/en-us/000133483/nfs-storage-solution-with-the-latest-dell-emc-storage-performance-results?lwp=rt)
- [IBM Storage Scale](https://www.ibm.com/products/storage-scale)


# NFSv3 vs NFSv4 according to [netapp](https://community.netapp.com/t5/Tech-ONTAP-Blogs/NFSv3-and-NFSv4-What-s-the-difference/ba-p/441316)
- NFSv4 is significantly different from NFSv3, NFSv4 isn't better than NFSv3, but different.
- It's easier to run NFSv4 across a firewall because it uses a single target port (2049)
- NFSv4 is stateful, it tracks which clients are using which filesystems, which files exist, which files and/or regions of files are locked, etc. NFSv4 clients are required to renew leases on files and filesystems on regular basis.  This activity keeps the TCP session active
- NFSv3 is stateless
- NFSv3 tolerates network interruption, but NFSv4 is more sensitive and imposes a defined lease period

Biggest benefit of NFSv4.2:
Server-side file copy: if you are on your client device, and you move a 2GB file within the shared folder to a different location in the shared folder (e.g. subfolder), with NFSv3 and NFSv4.1 the file would first be copied (downloaded) to your client device and then copied to the subfolder (uploaded). Server-side-copy was introduced in NFSv4.2 among other useful features.

We assume the latest version of NFS is better, so in the following benchmark, we will test NFSv4.2


# Linux NFS Replication solutions
- Block level replication with DRBD 
- Filesystem level replication GlustserFS / Ceph (not recommended due to high complexity)
- rsync to another NFS server (not recommended due to low performance)
- ZFS native clustering capabilities


# NFS Backup
- tar
- veeam
- filesystem level backup for CoW filesystem at zero cost

# 1. Install Linux [nfs-kernel-server](https://docs.kernel.org/filesystems/nfs/index.html) (aka nfsd) on debian
## 1.1 [NFS Server Setup](https://wiki.debian.org/NFSServerSetup) (other guide [here](https://github.com/zilexa/Homeserver/blob/master/Filesystems-guide/networkshares_HowTo-NFSv4.2/README.md))
```bash
sudo apt update
sudo apt install nfs-kernel-server -y
sudo systemctl stop nfs-server

# Disable rpcbind because NFSserver will start it, but NFSv4 does not use it
sudo systemctl mask rpcbind.service
sudo systemctl mask rpcbind.socket

# Configure NFS server to use NFSv4.2 only
cat << EOF | sudo tee /etc/default/nfs-common | sudo tee /etc/default/nfs-kernel-server
RPCNFSDOPTS="-N 2 -N 3"
RPCMOUNTDOPTS="--manage-gids -N 2 -N 3"
NEED_STATD="no"
NEED_IDMAPD="yes"
NEED_GSSD="no"
EOF
sudo sed -i '/vers4.0=/c\vers4.0=n' /etc/nfs.conf
sudo sed -i '/vers4.1=/c\vers4.1=n' /etc/nfs.conf
sudo sed -i '/vers3=/c\vers3=n' /etc/nfs.conf


# NFS shared directory is /var/nfs/general
sudo mkdir /var/nfs/general -p
sudo chown nobody:nogroup /var/nfs/general
sudo cat << EOF | sudo tee /etc/exports
/var/nfs/general   *(rw,sync,fsid=0,crossmnt,no_subtree_check,anonuid=1000,anongid=1000)
EOF
sudo systemctl start nfs-server
sudo systemctl status nfs-server

# Check NFS options and Read logs
cat /proc/fs/nfsd/versions 
# you must have "-3 +4 -4.0 -4.1 +4.2"

journalctl -u nfs-server -f
```

## 1.2 NFS Client Setup
Write the host ip in a variable, then test the network connectivity between client and server with a tcp packet on port 2049. Change the *host_ip* variable to the corresponding ip of the nfs server.
```bash
host_ip="10.0.99.196"
# Send a TCP packet on port 2049
timeout 1 bash -c "cat < /dev/null > /dev/tcp/$host_ip/2049" && echo "Successfuly sent a TCP packet on port 2049"
sudo showmount -e $host_ip
```

Then setup the NFS client.
```bash
sudo apt update
sudo apt install nfs-common fio -y
sudo mkdir -p /nfs/general

# mount command
sudo mount -t nfs -o nfsvers=4,minorversion=2,proto=tcp,fsc,nocto -vvvv $host_ip:/ /nfs/general

# persist the mount after reboots
echo "$host_ip:/ /nfs/general  nfs4  nfsvers=4,minorversion=2,proto=tcp,fsc,nocto  0  0" >> /etc/fstab

# Reboot
reboot
```

Check if the mount exists
```bash
sudo cat /proc/mounts | grep nfs
```

Removes nfs mount
```bash
sudo umount -l /nfs/general
```

Write to the share storage
```bash
echo "Hello" > /nfs/general/test.txt
```

# Benchmark
- https://www.iozone.org/

-- 
FIO
```bash
# Mixed Random Read/Write
# Performs 4 KB reads and writes using a 75%/25% split in the file, with 64 operations running at a time
sudo fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --bs=4k --iodepth=64 --readwrite=randrw --rwmixread=75 --size=1G --filename=/nfs/general/testfile

# Measuring sequential IOPS
# Read IOPS
fio --name=seq_read_iops --ioengine=libaio --directory=/nfs/general --direct=1 --blocksize=4K --readwrite=read --filesize=100M --end_fsync=1 --numjobs=8 --iodepth=64 --runtime=60 --group_reporting --time_based=1

# Write IOPS
fio --name=seq_write_iops --ioengine=libaio --directory=/nfs/general --direct=1 --blocksize=4K --readwrite=write --filesize=100M --end_fsync=1 --numjobs=8 --iodepth=64 --runtime=60 --group_reporting --time_based=1

# Measuring random IOPS
# Read IOPS
fio --name=rnd_read_iops --ioengine=libaio --directory=/nfs/general --direct=1 --blocksize=4K --readwrite=randread --filesize=100M --end_fsync=1 --numjobs=8 --iodepth=64 --runtime=60 --group_reporting --time_based=1

# Write IOPS
fio --name=rnd_write_iops --ioengine=libaio --directory=/nfs/general --direct=1 --blocksize=4K --readwrite=randwrite --filesize=100M --end_fsync=1 --numjobs=8 --iodepth=64 --runtime=60 –group_reporting –time_based=1
```

File Operations
```bash
testdir=/nfs/general/test
sudo mkdir -p $testdir
cd $testdir
# Write performance, read real time
TIMEFORMAT=%R
echo "Write Operations per second:"
{ time for i in {0..1000}; do echo 'test' > "test${i}.txt"; done; } 2>&1 | python3 -c 'import sys; print(1000/float(sys.stdin.readline().rstrip("\n")))'

# Read performance
echo "Read Operations per second:"
{ time for i in {0..1000}; do cat "test${i}.txt" > /dev/null; done } 2>&1 | python3 -c 'import sys; print(1000/float(sys.stdin.readline().rstrip("\n")))'
```
