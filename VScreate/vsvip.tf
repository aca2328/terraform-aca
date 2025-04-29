resource "avi_vsvip" "vsvip_tf_vs" {
  cloud_ref = data.avi_cloud.vs_cloud.id
  name      = "vsvip-${var.vs_name}-${var.avi_cloud}"
  vip {
    auto_allocate_ip          = true
    vip_id                    = "1"
    ipam_network_subnet {
        network_ref = data.avi_network.vs_network.id
        subnet {
            ip_addr {
                addr = var.vip_subnet
                type = "V4"
            }
            mask = var.vip_subnet_masklen
        }
    }
  }
}