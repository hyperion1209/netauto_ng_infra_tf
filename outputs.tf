output "service_attrs" {
  value = {
    grafana    = module.grafana[*].service_attrs
    prometheus = module.prometheus[*].service_attrs
    keycloak   = module.keycloak[*].service_attrs
  }
}

output "service_urls" {
  value = module.ingress[*]
}
