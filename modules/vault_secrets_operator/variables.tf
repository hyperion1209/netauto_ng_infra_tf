variable "clients" {
  type = map(
    object({
      namespace = string
      secrets   = list(string)
    })
  )
}
