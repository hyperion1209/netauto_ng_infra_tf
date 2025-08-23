locals {
  service_name = "kube-prometheus-stack"
  app_name     = "grafana"
  keycloak_url = "https://keycloak.${var.domain_name}"
  grafana_url  = "https://${local.app_name}.${var.domain_name}"
}
