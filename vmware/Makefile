VARYML?=vars.yml

.PHONY: dhcp

help: 
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'

checks:
	ansible-playbook checks.yml -e @$(VARYML)

manager: checks ## 01 Create and configure a DHCP server
	ansible-playbook -i hosts manager/manager.yml -e @$(VARYML)

dhcp2: 	
	ansible localhost -o -m template -a "src=dhcp/main.tf dest=/tmp/tf/" -e @$(VARYML)
	. ./env.sh && cd /tmp/tf && terraform init && terraform plan && terraform apply -auto-approve

esxis:  	## 02 Create ESXis
	ansible localhost -o -m template -a "src=esxi/packer_esxi.json dest=/tmp" -e @$(VARYML)
	packer build /tmp/packer_esxi.json

##
clean:		## zz Clean temp directories
	rm -rf /tmp/c95
