variable vsphere_user { type = string }
variable vsphere_password { type = string }
variable ssh_password { type = string }

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = "{{ vsphere_vcenter }}"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
    name = "{{ vsphere_datacenter }}"
}

data "vsphere_datastore" "datastore" {
  name          = "{{ vsphere_datastore }}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "{{ vsphere_cluster }}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
  name = "{{ vsphere_resource_pool.split('/')[-1] }}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "{{ vsphere_network }}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "source_template" {
  name          = "{{ vm_template }}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "dhcp_vm" {
  name = "dhcp-{{ nested_env }}"
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "{{ vsphere_folder }}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  num_cpus = 2
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.source_template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.source_template.network_interface_types[0]
  }
 
  disk {
    label = "disk0"
    size             = 2000
    thin_provisioned = true
  }
  
  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id
    timeout = 120

    customize {
      linux_options {
        host_name = "dhcp-{{ nested_env }}"
        domain = "adlere.priv"
      }

      network_interface {
        ipv4_address = "{{ dhcp_ip }}"
        ipv4_netmask = {{ netmask_short }}
      }
    
      ipv4_gateway = "{{ gateway }}"
      dns_server_list = ["{{ dns1 }}", "{{ dns2 }}"]
    }  
  }

  provisioner "file" {
      source = "{{ ssh_public_key }}"
      destination = "/root/.ssh/authorized_keys"
  }


  connection  {
    user           = "root"
    password       = var.ssh_password
    timeout = 15
    host  = "{{ dhcp_ip }}"
  }  
}