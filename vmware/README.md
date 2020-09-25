# Nested VSphere environment

## Requirements
- packer
- terraform
- ansible
- linux environment
- centos template vm
- esxi template vm (see esxi/prepare.sh)
- vcsa template vm (see vcsa/prepare.sh)
- nsx template vm
```
export VSPHERE_USER="admin"
export VSPHERE_PASSWORD="VMware1!VMware1!"
export VM_TEMPLATE_PASSWORD='kernet'
```

## 01 - Manager
```
make manager
```

## 02 - Esxi
```
make esxi
```

## 03 - VCSA
```
make vcsa
```

## 04 - NSX-T
```
make nsx
```