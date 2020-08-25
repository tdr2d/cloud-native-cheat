#!/bin/sh

set -euo pipefail

# Usage: ./dnsmask-static-pxe.sh http://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-desktop-amd64.iso 00:50:56:a5:42:43 192.168.95.43 eth0
#
# Setup pxe / httpd server to boot server over pxe
# It will download the iso, mount it and expose it content on the httpd

ISO="${1:-http://releases.ubuntu.com/20.04.1/ubuntu-20.04.1-desktop-amd64.iso}"
MAC="${2-00:50:56:a5:42:43}"
IP="${3-192.168.95.43}"
INTERFACE="${4-eth0}"

ISO_SUFFIX=$(echo $ISO | rev | cut -d"/" -f1 | rev )  # basename of iso file
ISO_NAME="/var/lib/tftpboot/${ISO_SUFFIX}"            # path of iso
BOOT_DIR=$(echo $ISO_SUFFIX | head -c 6)
IP_ADDR=$(hostname -I)
DNSS=$(grep "nameserver" /etc/resolv.conf | cut -d' ' -f2 | tr '\n' ',')
GATEWAY=$(ip route | grep "default" | cut -d' ' -f3)
DEV=$(ip route | grep "default" | cut -d' ' -f5)
SUBNET=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')

[ ! -e /etc/dnsmasq.conf ] && yum install dnsmasq -y
[ ! $(command -v curl) ] && yum install curl -y
[ ! -d /var/www/html ] && yum install httpd -y

# HTTPD
mount -o loop $ISO_NAME /mnt/
cp -rf /mnt/* $BOOT_DIR
umount /mnt
chown -R apache:apache $BOOT_DIR
systemctl enable httpd && systemctl start httpd
echo "Exposing iso boot files on http://${IP_ADDR}/$BOOT_DIR"

# TFTP
mkdir -p /var/lib/tftpboot/pxelinux/pxelinux.cfg
[ ! -e $ISO_NAME ] && curl -L $ISO -o $ISO_NAME

# DNSMASQ
cat << EOF > /etc/dnsmasq.conf
interface=${INTERFACE}
dhcp-range=${IP},static,infinite
dhcp-option=3,${GATEWAY}
dhcp-option=6,${DNSS}
dhcp-host=${MAC},${IP},svr1,infinite
dhcp-boot=/${BOOT_DIR}/pxelinux.0,pxeserver,${IP_ADDR}
enable-tftp
tftp-root=/var/lib/tftpboot
EOF
mkdir -p /var/lib/tftpboot/${BOOT_DIR}
systemctl enable dnsmaq && systemctl restart dnsmasq
systemctl disable firewalld && systemctl stop firewalld

echo "Expected to have /var/lib/tftpboot/${BOOT_DIR}/pxelinux.0"

