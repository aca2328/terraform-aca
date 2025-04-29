variable "avi_username" {
  type    = string
  description = "Username for API connection to Avi Controller"
  default = "admin"
}

variable "avi_password" {
  type    = string
  description = "Password for API connection to Avi Controller"
  sensitive = true
}

variable "avi_controller" {
  type    = string
  description = "FQDN or IP Address of Avi Controller"
}

variable "avi_version" {
  type    = string
  description = "Avi API Version"
  default = "31.1.1"
}

variable "avi_tenant" {
  type    = string
  description = "Tenant to use for API session"
  default = "admin"
}

variable "avi_api_timeout" {
  type    = number
  description = "Timeout for API calls to Avi Controller"
  default = 20
}