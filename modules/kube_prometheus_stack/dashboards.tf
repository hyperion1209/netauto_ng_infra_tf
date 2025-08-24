resource "kubernetes_config_map_v1" "dashboard" {
  for_each = local.dashboards
  metadata {
    name      = each.key
    namespace = local.namespace
    labels = {
      grafana_dashboard = "1"
    }
  }
  data = {
    "${each.key}.json" = file(each.value)
  }
}
