#
# Certificate Issuer
#
module "cert_issuer" {
  source = "./modules/cert_issuer"
}

#
# Domain
#
resource "civo_dns_domain_name" "this" {
  name = local.domains[local.profile]
}

#
# Services
#
module "prometheus" {
  count  = local.enabled_services.prometheus ? 1 : 0
  source = "./modules/prometheus"
}

module "grafana" {
  count  = local.enabled_services.grafana ? 1 : 0
  source = "./modules/grafana"
  prometheus_ip = module.prometheus[0].service_attrs.ip
  prometheus_port = module.prometheus[0].service_attrs.port
}

#
# Service Ingress
#
module "ingress" {
  for_each     = local.ingress_services
  source       = "./modules/ingress"
  domain_id    = civo_dns_domain_name.this.id
  domain_name  = civo_dns_domain_name.this.name
  lb_public_ip = data.civo_loadbalancer.traefik.public_ip
  service_name = each.key
  service_port = each.value

  providers = {
    civo = civo
  }
}
