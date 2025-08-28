output "service_attrs" {
  value = {
    keycloak = module.keycloak[*].service_attrs
  }
}
