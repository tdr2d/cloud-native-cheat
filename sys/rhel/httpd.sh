#!/bin/bash

set -eu

yum install -y httpd
systemctl enable httpd
systemctl restart httpd

if [ "$(firewall-cmd --status)" = "running" ]; then
  # todo check  firewall-cmd --get-default-zone
  # todo check  firewall-cmd --get-active-zones
  firewall-cmd --zone=public --permanent --add-service=http
  firewall-cmd --zone=public --permanent --add-service=https
fi