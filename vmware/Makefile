VARYML?=vars.yml

.PHONY: dhcp

help: 
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'

checks:
	ansible-playbook checks.yml -e @$(VARYML)


install: ## Install locally needed roles
	sudo pip install pyvmomy
	ansible-galaxy install bertvv.dnsmasq
	ansible-galaxy install geerlingguy.nfs

manager: checks ## 01 Create and configure a DHCP server
	ansible-playbook -i hosts manager/manager.yml -e @$(VARYML)
esxi: checks 	## 02 Create ESXis
	ansible-playbook -i hosts esxi/esxi.yml -e @$(VARYML)
vsca: check
	ansible-playbook -i hosts esxi/esxi.yml -e @$(VARYML)

##
clean:		## zz Clean temp directories
	rm -rf /tmp/c95
