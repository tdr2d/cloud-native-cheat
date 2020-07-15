#!/bin/sh

set -euo pipefail

create_password() { echo "$(openssl rand -base64 ${1:-9} 2>/dev/null)"; }
chline() { 
    if [[ $# -ne 3 ]]; then echo "Usage: chline \"TOKEN_IN_LINE\" \"NEW_LINE\" file"; return 1; fi
    sed -i "/$1/c\
$2" $3
}
replace() {
    if [[ $# -ne 3 ]]; then echo "Usage: replace \"TOKEN_IN_LINE\" \"NEW_TOKEN\" file"; return 1; fi
    sed -i "/$1/$2" $3
}

PASS_ESXI_1=$(create_password)
PASS_ESXI_2=$(create_password)
PASS_ESXI_3=$(create_password)
PASS_ESXI_4=$(create_password)

save_passwords() {
    cat << EOF > ${1-/dev/stdout}
PASS_ESXI_1=$PASS_ESXI_1
PASS_ESXI_2=$PASS_ESXI_2
PASS_ESXI_3=$PASS_ESXI_3
PASS_ESXI_4=$PASS_ESXI_4
EOF
}
# save_passwords

ESXI_ISO="VMware-VMvisor-Installer-7.0.0-15843807.x86_64.iso" # absolute or relative (no ~)
create_custom_iso() {
    # https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.upgrade.doc/GUID-C03EADEA-A192-4AB4-9B71-9256A9CB1F9C.html#GUID-C03EADEA-A192-4AB4-9B71-9256A9CB1F9C
    mkdir -p /media/cdrom
    mount -o loop $ESXI_ISO /media/cdrom
    cp -r /media/cdrom cdrom

    cd cdrom
    sed -i '/kernelopt=/c\kernelopt=runweasel ks=cdrom:/ks_cust.cfg' boot.cfg
    update_line 'kernelopt=' 'test' boot.cfg
}