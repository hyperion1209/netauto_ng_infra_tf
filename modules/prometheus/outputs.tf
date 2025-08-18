output "service_attrs" {
  value = {
    ip   = data.kubernetes_service_v1.prometheus.spec[0].cluster_ip
    port = data.kubernetes_service_v1.prometheus.spec[0].port[0].port
  }
}
