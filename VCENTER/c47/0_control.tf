terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = ">= 1.24.2"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "wdc-06-vc12"
}
data "vsphere_datastore" "datastore" {
  name          = "wdc-06-vc12c01-vsan"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_compute_cluster" "cluster" {
    name          = "wdc-06-vc12c01"
    datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool" {
  name          = "wdc-06-vc12c01-tkg"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = "vxw-dvs-34-virtualwire-3-sid-6120002-wdc-06-vc12-avi-mgmt"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = "wdc-06-r08esx11.oc.vmware.com"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}-${count.index+1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datacenter_id = data.vsphere_datacenter.dc.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id = data.vsphere_host.host.id
  count = 1

  num_cpus = 8
  memory = 24576

  folder = var.vm_folder
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0
  
  network_interface {
      network_id = data.vsphere_network.network.id
  }
  
  disk {
      label = "disk1"
      size = 130
      thin_provisioned = false
  }

  ovf_deploy {
	remote_ovf_url	= "http://10.206.112.50/controller-20.1.2-9171.ova"
  disk_provisioning    = "thin"
   ovf_network_map = {
        "VM Network" = data.vsphere_network.network.id
   }
  }
}
