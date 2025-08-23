output "service_attrs" {
  value = {
    grafana    = module.grafana[*].service_attrs
    prometheus = module.prometheus[*].service_attrs
    keycloak   = module.keycloak[*].service_attrs
  }
}
