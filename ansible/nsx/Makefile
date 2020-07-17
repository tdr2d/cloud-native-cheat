export ANSIBLE_RETRY_FILES_ENABLED=0
export ANSIBLE_HOST_KEY_CHECKING=False


help:
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'

install:	  ## Install dependencies for using the ansible nsx-t module
	sudo pip3 install --upgrade pyvmomi pyvim
	cd /tmp && wget https://github.com/vmware/ansible-for-nsxt/archive/v3.0.0.zip && unzip v3.0.0.zip && rm v3.0.0.zip
	mkdir -p ~/.ansible/plugins/modules/
	cp -r /tmp/ansible-for-nsxt-3.0.0/{library,module_utils} .

delete_all_ncp:  ## Delete all openshift object
	# ansible-playbook delete_all_ncp.yml # shit doesn't work
	./nsxt.py --user admin --nsx-manager 192.168.95.6 --cluster ocp4-nsx --delete