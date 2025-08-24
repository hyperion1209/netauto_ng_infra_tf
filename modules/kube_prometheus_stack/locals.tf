locals {
  namespace    = "kube-prometheus-stack"
  app_name     = "grafana"
  keycloak_url = "https://keycloak.${var.domain_name}"
  grafana_url  = "https://${local.app_name}.${var.domain_name}"
  # Dashboard name to file path mapping
  dashboards = tomap({
    for fn in fileset("${path.module}/dashboards", "*.json") : replace(fn, ".json", "") => "${path.module}/dashboards/${fn}"
  })
}
