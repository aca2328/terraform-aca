resource "avi_pool" "pool_tf_vs" {
  cloud_ref = data.avi_cloud.vs_cloud.id
  name      = "${var.vs_name}-pool"

  dynamic "servers" {
    for_each = var.pool_servers
    content {
      ip {
        addr = servers.value
        type = "V4"
      }
    }
  }

  health_monitor_refs = [ data.avi_healthmonitor.system_http_hm.id ]
  lb_algorithm = "LB_ALGORITHM_LEAST_LOAD"
}