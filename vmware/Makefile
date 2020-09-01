VARYML?=vars.yml

template:
	ansible localhost -m template -a "src=esxi/packer_esxi.json dest=/tmp" -e @$(VARYML)
	packer build /tmp/packer_esxi.json
