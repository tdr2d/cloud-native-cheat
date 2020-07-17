#!/bin/bash

set -euo pipefail
source ./lib/color.sh

# Usage: ./ssh_gen.sh id_rsa [~/.ssh]

## Generate a keypair
gen_keypair() {
    local name="${1:-sshkey}"
    local dir=${2:-~/.ssh}

    ssh-keygen -b 2048 -t rsa -f $dir/$name -q -N ""
    printf "Created keypair ${dir}/${name} and ${dir}/${name}.pub\n\nAdd public key to user@server:~/.ssh/authorized_keys:\n"
    printf "${Gre}echo '$(cat ${dir}/${name}.pub)' >> ~/.ssh/authorized_keys\n\n${RCol}"
    printf "\nRun this to automatically add key to ssh-agent: \n${Gre}ssh-agent bash\nssh-add ${dir}/${name}\n${RCol}"
}

gen_keypair ${1:-test}