

variable "vm_name" {
  type    = string
  default = "controller-terra"
}

variable "vm_folder" {
  type    = string
  default = "Antoine"
}

variable "vsphere_user" {
  type = string
  default = "aviuser6"
}

variable "vsphere_password" {
  type = string
  default = "AviUser1234!."
}

variable "vsphere_server" {
  type = string
  default = "10.206.12.11"
}
