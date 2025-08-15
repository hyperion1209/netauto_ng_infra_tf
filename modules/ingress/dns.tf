resource "civo_dns_domain_record" "this" {
  domain_id = var.domain_id
  type      = "A"
  name      = var.service_name
  value     = var.lb_public_ip
  ttl       = 600
}
