variable "prometheus_attrs" {
  type = object({
    ip   = string
    port = number
  })
}

variable "keycloak_creds" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  type = string
}

variable "storage_class_name" {
  type = string
}
