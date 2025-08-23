resource "civo_dns_domain_record" "this" {
  for_each  = var.namespace_apps
  domain_id = var.domain_id
  type      = "A"
  name      = each.key
  value     = var.lb_public_ip
  ttl       = 600
}
