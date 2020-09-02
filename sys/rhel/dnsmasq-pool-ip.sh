#!/bin/sh

set -euo pipefail

# usage: ./dnsmask-pool-ip.sh ens192 192.168.95.43 192.168.95.50 192.168.95.254 192.168.95.254,192.168.145.2
#                              dev   start         end           gateway        dns1,dns2

readonly INTERFACE="${1:-eth0}"
readonly START="${2-192.168.95.43}"
readonly END="${3-192.168.95.43}"
readonly GATEWAY="${4-192.168.95.254}"
readonly DNS="${5-192.168.95.254}"

[ ! -e /etc/dnsmasq.conf ] && yum install dnsmasq -y

# DNSMASQ https://wiki.archlinux.org/index.php/dnsmasq#DHCP_server
cat << EOF > /etc/dnsmasq.conf
port=0
interface=${INTERFACE}
dhcp-range=${START},${END},1h
dhcp-option=3,${GATEWAY}
dhcp-option=6,${DNS}
EOF
dnsmasq --test
systemctl enable dnsmaq
systemctl restart dnsmasq