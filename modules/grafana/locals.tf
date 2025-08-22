locals {
  service_name   = "grafana"
  prometheus_url = "http://${var.prometheus_attrs.ip}:${var.prometheus_attrs.port}"
  keycloak_url   = "https://keycloak.${var.domain_name}"
  grafana_url    = "https://${local.service_name}.${var.domain_name}"
}
