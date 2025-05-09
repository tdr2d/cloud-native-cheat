#!bin/sh

# If you have DNS Issues, because your /etc/resolv.conf uses a local DNS server which does not exist
# Run as Root
sudo resolvectl dns ens3 8.8.8.8 8.8.4.4
sudo systemctl restart systemd-resolved.service

# Test DNS resolution
ping -c 1 google.com