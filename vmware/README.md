# Nested VSphere environment

## Requirements
- packer
- terraform
- ansible
- linux environment
```
export VSPHERE_USER="admin"
export VSPHERE_PASSWORD="VMware1!VMware1!"
export VM_TEMPLATE_PASSWORD='kernet'
```

## 00 - Esxi Template (Optional)
```
make template
```

## 01 - Dhcp
```
make dhcp
```

## 02 - ESXis
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