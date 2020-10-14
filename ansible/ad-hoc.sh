

# Init new role
ansible-galaxy role init vm-provision

# Templates
ansible localhost -m template -a 'src=packer.json dest=/tmp/packer.json' -e @/tmp/vars.yml \
    -e template_ip=192.168.95.242 \
    -e template_hostname=t-rhel-7-8.adlere.priv
    -e kernet_ssh_pass=$KERNET_SSH_PASS

