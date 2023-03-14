

# install ansible 
pip3 install ansible
pip3 install passlib

# Install ansible playbook
python3 -m ansible galaxy install --ignore-certs cloudalchemy.node_exporter

# Deploy nodeexporter on servers
export ANSIBLE_HOST_KEY_CHECKING=False
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES # https://stackoverflow.com/questions/50168647/multiprocessing-causes-python-to-crash-and-gives-an-error-may-have-been-in-progr

python3 -m ansible adhoc all -i hosts -b -m ansible.builtin.apt -a "name=* state=latest"
python3 -m ansible adhoc all -i hosts -b -m ansible.builtin.apt -a "name=ca-certificates state=present"
python3 -m ansible adhoc all -i hosts -b -m ansible.builtin.reboot
python3 -m ansible playbook -b -i hosts playbook.yml
