variable "clients" {
  type = map(
    object({
      namespace = string
    })
  )
}
