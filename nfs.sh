
# nfs server  192.168.0.1
yum install nfs-utils nfs-utils-lib -y
mkdir /public
touch /public/nfs1 /public/nfs2 /public/nfs3

cat << EOF >> /etc/exports
/public *(rw,sync)
EOF

service nfs start
showmount -e # debug public exports

# nfs client server 192.168.0.2
yum install nfs* -y

mount 192.168.0.1:/public /mnt/  # mount /public of the nfs server into /mnt of the client server
