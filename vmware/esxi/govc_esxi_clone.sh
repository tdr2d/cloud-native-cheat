#!/bin/bash

set -eu

hostname=$1
ip=$2

if [ "$#" -ne 2 ]; then
    echo "Usage: ./script.sh ip hostname"
    exit 1
fi

tmp=$(mktemp -d /tmp/nested67u3_XXXX)
trap "rm -rf $tmp" EXIT
cd $tmp

cat << EOF > $tmp/config.json
{
  "DiskProvisioning": "thin",
  "IPAllocationPolicy": "fixedPolicy",
  "IPProtocol": "IPv4",
  "PropertyMapping": [
    {
      "Key": "guestinfo.hostname",
      "Value": "$hostname"
    },
    {
      "Key": "guestinfo.ipaddress",
      "Value": "$ip"
    },
    {
      "Key": "guestinfo.netmask",
      "Value": "$VC_NETMASK"
    },
    {
      "Key": "guestinfo.gateway",
      "Value": "$VC_GATEWAY"
    },
    {
      "Key": "guestinfo.vlan",
      "Value": "$VC_VLAN"
    },
    {
      "Key": "guestinfo.dns",
      "Value": "$VC_DNS1 $VC_DNS2"
    },
    {
      "Key": "guestinfo.domain",
      "Value": "${hostname}.${VC_DNS_SEARCH}"
    },
    {
      "Key": "guestinfo.ntp",
      "Value": "pool.ntp.org"
    },
    {
      "Key": "guestinfo.syslog",
      "Value": "192.168.1.200"
    },
    {
      "Key": "guestinfo.password",
      "Value": "VMware1!"
    },
    {
      "Key": "guestinfo.ssh",
      "Value": "True"
    },
    {
      "Key": "guestinfo.createvmfs",
      "Value": "True"
    }
  ],
  "NetworkMapping": [
    {
      "Name": "VM Network",
      "Network": "$GOVC_NETWORK"
    }
  ],
  "Annotation": "Nested ESXi 7.0 Appliance (Build 15843807)",
  "MarkAsTemplate": false,
  "PowerOn": true,
  "InjectOvfEnv": false,
  "WaitForIP": false,
  "Name": "$hostname"
}
EOF

#cat $tmp/config.json
#govc import.ovf --name=$hostname --options=$tmp/config.json $ESXI_67U3_OVA
govc import.ovf --name=$hostname --options=$tmp/config.json -vm $ESXI_67U3_TEMPLATE -c 8 -m 64

# clone https://www.msystechnologies.com/blog/learn-how-to-install-configure-and-test-govc/
