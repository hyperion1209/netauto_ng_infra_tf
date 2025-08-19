variable "domain_id" {
  type = string
}

variable "domain_name" {
  type = string

}

variable "lb_public_ip" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_attrs" {
  type = object({
    namespace = optional(string)
    backend = object({
      port = number
      service = optional(string)
    })
  })
}
