source ~/.env.sh
export TF_VAR_vsphere_user="$VSPHERE_USER"
export TF_VAR_vsphere_password="$VSPHERE_PASSWORD"
export ANSIBLE_HOST_KEY_CHECKING=False

export GOVC_USERNAME="$VSPHERE_USER"
export GOVC_PASSWORD="$VSPHERE_PASSWORD"
export GOVC_INSECURE="True"