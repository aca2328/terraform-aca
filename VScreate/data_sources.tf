data "avi_cloud" "vs_cloud" {
  name = var.avi_cloud
}

data "avi_healthmonitor" "system_http_hm" {
  name = "System-HTTP"
}

data "avi_applicationprofile" "system_http_ap" {
 name = "System-HTTP"
}

data "avi_sslprofile" "standard_sslprofile" {
  name = "System-Standard-PFS"
}

data "avi_sslkeyandcertificate" "wildcard_cert" {
  name = "System-Default-Cert-EC"
}

data "avi_network" "vs_network" {
    name = var.vip_network
}