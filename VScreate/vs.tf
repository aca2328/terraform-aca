resource "avi_virtualservice" "vs_tf_vs" {
  cloud_ref = data.avi_cloud.vs_cloud.id
  name      = var.vs_name

  vsvip_ref = avi_vsvip.vsvip_tf_vs.id
  pool_ref = avi_pool.pool_tf_vs.id
  application_profile_ref = data.avi_applicationprofile.system_http_ap.id
  services {
    port = 80
  }
  services {
    port = 443
    enable_ssl = true
  }
  ssl_profile_ref = data.avi_sslprofile.standard_sslprofile.id
  ssl_key_and_certificate_refs = [ data.avi_sslkeyandcertificate.wildcard_cert.id ]
}