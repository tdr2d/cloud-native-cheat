VARYML?=vars.yml

help: 
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'

template: 	## 00 Create the 	ESXi Template (Optional)
	ansible localhost -m template -a "src=esxi/packer_template.json dest=/tmp" -e @$(VARYML)
	packer build /tmp/packer_template.json

.PHONY: dhcp
dhcp: 		## 01 Create and configure a DHCP server
	ansible localhost -m template -a "src=dhcp/packer_dhcp.json dest=/tmp" -e @$(VARYML)
	packer build /tmp/packer_dhcp.json; rm /tmp/packer_dhcp.json

esxis:  	## 02 Create ESXis
	ansible localhost -m template -a "src=esxi/packer_esxi.json dest=/tmp" -e @$(VARYML)
	packer build /tmp/packer_esxi.json