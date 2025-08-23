variable "domain_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "lb_public_ip" {
  type = string
}

variable "namespace" {
  type = string
}

variable "namespace_apps" {
  type = map(
    object({
      port         = number
      service_name = optional(string)
    })
  )
}
