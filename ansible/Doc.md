# Read variable precedence
https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable


# Custom filter
https://dev.to/aaronktberry/creating-custom-ansible-filters-29kf



# Bugs
```
# Do not use public attributes
# https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#creating-valid-variable-names
debug: var=var.items              # items property is a buildins, use var['items'] 
```

### WSL Bug
https://community.spiceworks.com/topic/2275812-ubuntu-wsl-ansible-permission-error-when-running-localhost-playbook