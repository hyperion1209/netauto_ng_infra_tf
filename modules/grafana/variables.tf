variable "prometheus_attrs" {
  type = object({
    ip = string
    port = number
  })
}

variable "keycloak_attrs" {
  type = object({
    ip = string
    port = number
  })
}

variable "storage_class_name" {
  type = string
}
