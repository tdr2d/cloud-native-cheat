#!/bin/sh

set -euo pipefail

START="${1-192.168.95.43}"
END="${1-192.168.95.43}"

[ ! -e /etc/dnsmasq.conf ] && yum install dnsmasq -y

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