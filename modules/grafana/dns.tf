resource "civo_dns_domain_name" "grafana" {
  name = "netauto-ng-dev.org"
}

resource "civo_dns_domain_record" "grafana" {
  domain_id  = civo_dns_domain_name.grafana.id
  type       = "A"
  name       = "www"
  value      = var.lb_public_ip
  ttl        = 600
  depends_on = [civo_dns_domain_name.this]
}
