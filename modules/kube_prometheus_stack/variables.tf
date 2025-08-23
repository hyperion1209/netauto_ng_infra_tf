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
