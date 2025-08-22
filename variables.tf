variable "CIVO_TOKEN" {
  type      = string
  sensitive = true
  default   = ""
}

variable "grafana_keycloak_creds" {
  type      = string
  sensitive = true
}
