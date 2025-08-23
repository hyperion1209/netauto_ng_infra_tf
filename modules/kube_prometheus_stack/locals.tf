locals {
  service_name   = "kube-prometheus-stack"
  keycloak_url   = "https://keycloak.${var.domain_name}"
  grafana_url    = "https://${local.service_name}.${var.domain_name}"
}
