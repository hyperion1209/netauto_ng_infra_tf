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
module "keycloak" {
  count  = local.enabled_services.keycloak ? 1 : 0
  source = "./modules/keycloak"
}

module "vault" {
  count  = local.enabled_services.vault ? 1 : 0
  source = "./modules/vault"
}

module "prometheus" {
  count              = local.enabled_services.prometheus ? 1 : 0
  source             = "./modules/prometheus"
  storage_class_name = local.k8s_cluster.storage_class_name
}

module "grafana" {
  count              = local.enabled_services.grafana && local.enabled_services.prometheus && local.enabled_services.keycloak ? 1 : 0
  source             = "./modules/grafana"
  prometheus_attrs   = module.prometheus[0].service_attrs
  keycloak_attrs     = module.keycloak[0].service_attrs
  storage_class_name = local.k8s_cluster.storage_class_name
}

#
# Service Ingress
#
module "ingress" {
  for_each      = local.ingress_services
  source        = "./modules/ingress"
  domain_id     = civo_dns_domain_name.this.id
  domain_name   = civo_dns_domain_name.this.name
  lb_public_ip  = data.civo_loadbalancer.traefik.public_ip
  service_name  = each.key
  service_attrs = each.value

  depends_on = [
    module.grafana,
    module.keycloak,
    # module.vault
  ]

  providers = {
    civo = civo
  }
}
