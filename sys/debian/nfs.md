# Benchmark commands
Existing Benchmark results: https://en.wikipedia.org/wiki/Network_File_System#/media/File:NfsPerformanceGraph.png

- fio https://learn.microsoft.com/en-us/azure/storage/blobs/network-file-system-protocol-performance-benchmark
- fio https://docs.gitlab.com/administration/operations/filesystem_benchmarking/
- NFStest https://wiki.linux-nfs.org/wiki/index.php/NFStest



# NFS solutions
**[nfs-ganesha](https://github.com/nfs-ganesha/nfs-ganesha/wiki/Setup)** comes as the first NFS server open-source solution, however is not completely mature.
It does not provide its own clustering support, but HA can be achieved using Linux HA, via GlusterFS, or CephFS.
It supports NFSv3 and NFSv4.

**[unfs3](https://github.com/unfs3/unfs3)** is another interesting project. It supports NFSv3 only.
HA mode is supported via the AFS network filesystem.

**nfs-kernel-server aka nfsd**
Is developped within the linux kernel, so in the linux git repository.


# [NFSv3 vs NFSv4](https://community.netapp.com/t5/Tech-ONTAP-Blogs/NFSv3-and-NFSv4-What-s-the-difference/ba-p/441316)
- NFSv4 is significantly different from NFSv3, NFSv4 isn't better than NFSv3, but different.
- It's easier to run NFSv4 across a firewall because it uses a single target port (2049)
- NFSv4 is stateful, it tracks which clients are using which filesystems, which files exist, which files and/or regions of files are locked, etc. NFSv4 clients are required to renew leases on files and filesystems on regular basis.  This activity keeps the TCP session active
- NFSv3 is stateless
- NFSv3 tolerates network interruption, but NFSv4 is more sensitive and imposes a defined lease period

We assume the latest version of NFS is better, so in the following benchmark, we will test NFSv4.2

# 1. Linux [nfs-kernel-server](https://docs.kernel.org/filesystems/nfs/index.html) (nfsd)
## 1.1 [Server Setup](https://wiki.debian.org/NFSServerSetup)
We make sure that the sync option is used
```bash
sudo apt update
sudo apt install nfs-kernel-server -y
# Configure nfsd for exposing NFSv4 Only
sudo sed -i '/NEED_STATD=/c\NEED_STATD="no"' /etc/default/nfs-common
sudo sed -i '/NEED_IDMAPD=/c\NEED_IDMAPD="yes"' /etc/default/nfs-common
sudo sed -i '/RPCNFSDOPTS=/c\RPCNFSDOPTS="-N 2 -N 3"' /etc/default/nfs-kernel-server
sudo sed -i '/RPCMOUNTDOPTS=/c\RPCMOUNTDOPTS="--manage-gids -N 2 -N 3"' /etc/default/nfs-kernel-server

# NFS shared directory is /var/nfs/general
sudo mkdir /var/nfs/general -p
sudo chown nobody:nogroup /var/nfs/general
sudo cat << EOF | sudo tee /etc/exports
/var/nfs/general   *(rw,sync,fsid=0,crossmnt,no_subtree_check)
EOF
sudo systemctl restart nfs-kernel-server
sudo systemctl status nfs-kernel-server

# Read logs
journalctl -u nfs-server -f
```

## 1.2 Client Setup
Write the host ip in a variable, then test the network connectivity between client and server with a tcp packet on port 2049.
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
sudo mount -t nfs4 -vvvv $host_ip:/ /nfs/general
```

Check if the mount exist
```bash
sudo cat /proc/mounts | grep nfs
```

Removes nfs mount
```bash
sudo umount -l /nfs/general
```

Write to share storage
```bash
echo "Hello" > /nfs/general/test.txt
```

## Benchmark
One big file. Performs 4 KB reads and writes using a 75%/25% split in the file, with 64 operations running at a time
```bash


# Mixed Random Read/Write
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

Multiple files
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
