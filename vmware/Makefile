VARYML?=vars.yml

.PHONY: dhcp

help: 
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'


## Utils
install_govc:
	curl -L https://github.com/vmware/govmomi/releases/download/v0.23.0/govc_linux_amd64.gz | gunzip > /usr/local/bin/govc
	chmod +x /usr/local/bin/govc

get_ova_properties:
	echo 'govc import.spec <ova_file> | python -m json.tool'

install: ## Install locally needed roles
	sudo pip install pyvmomy
	ansible-galaxy install geerlingguy.nfs

##
## Nested Env
checks:
	ansible-playbook checks.yml -e @$(VARYML)
manager: checks ## 01 Create and configure a DHCP server
	ansible-playbook -i hosts manager/manager.yml -e @$(VARYML)
esxi: checks 	## 02 Create nested ESXis
	ansible-playbook -i hosts esxi/esxi.yml -e @$(VARYML)
vcsa: checks 	## 02 Create nested VCSA
	ansible-playbook -i hosts vcsa/vcsa.yml -e @$(VARYML)

##
clean:		## zz Clean temp directories
	rm -rf /tmp/c95
