#!/bin/bash

set -eo pipefail

ADDITIONAL_IP=${1}
OUTPUT_FILE='/etc/netplan/51-cloud-init.yaml'
INTERFACE='ens3'

if [ -z ${ADDITIONAL_IP} ]; then
    echo "Wrong Usage: "
    echo "./set-public-ip.sh <my.ip.v.4>"
    exit 1
fi

rm -f $OUTPUT_FILE
cat << EOF > $OUTPUT_FILE
network:
  version: 2
  ethernets:
    ${INTERFACE}:
      dhcp4: true
      addresses:
        - ${ADDITIONAL_IP}/32
EOF
# sudo chmod 600 -R /etc/netplan/

echo "Writing netplan configution ${OUTPUT_FILE}"
cat $OUTPUT_FILE
echo "Applying configuration"

# sudo netplan try --timeout 3
sudo netplan apply