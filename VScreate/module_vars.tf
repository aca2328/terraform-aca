variable "avi_cloud" {
  type        = string
  description = "Cloud in which to create Virtual Service"
  default     = "Default-Cloud"
}

variable "avi_seg" {
  type        = string
  description = "SE Group in which to create Virtual Service"
  default     = "Default-Group" 
}

variable "vs_name" {
  type        = string
  description = "Name to use for Virtual Service and dependent objects"
  default     = "ac-terraform-demo" 
}

variable "vip_network" {
  type        = string
  description = "Network Name (PG) for VIP allocation"
}

variable "vip_subnet" {
  type        = string
  description = "IP Subnet for VIP allocation"
}

variable "vip_subnet_masklen" {
  type        = number
  description = "IP Subnet Mask Length for VIP allocation"
}

variable "pool_servers" {
  type        = list
  description = "List of Pool Server Addresses"
}
