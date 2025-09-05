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
  count       = local.enabled_services.keycloak ? 1 : 0
  source      = "./modules/keycloak"
  domain_name = civo_dns_domain_name.this.name
}

module "vault" {
  count              = local.enabled_services.vault ? 1 : 0
  source             = "./modules/vault"
  storage_class_name = local.k8s_cluster.storage_class_name
}

module "vault_secrets_operator" {
  count   = local.enabled_services.vault-secrets-operator && local.enabled_services.vault ? 1 : 0
  source  = "./modules/vault_secrets_operator"
  clients = local.vso_client_services
}

module "kube_prometheus_stack" {
  count              = local.enabled_services.kube-prometheus-stack ? 1 : 0
  source             = "./modules/kube_prometheus_stack"
  domain_name        = civo_dns_domain_name.this.name
  storage_class_name = local.k8s_cluster.storage_class_name

  depends_on = [module.vault_secrets_operator]
}

module "pulp" {
  count              = local.enabled_services.pulp ? 1 : 0
  source             = "./modules/pulp"
  storage_class_name = local.k8s_cluster.storage_class_name

  depends_on = [module.vault_secrets_operator]
}

module "jenkins" {
  count              = local.enabled_services.jenkins ? 1 : 0
  source             = "./modules/jenkins"
  storage_class_name = local.k8s_cluster.storage_class_name

  depends_on = [module.vault_secrets_operator]
}

#
# Service Ingress
#
module "ingress" {
  for_each       = local.ingress_services
  source         = "./modules/ingress"
  domain_id      = civo_dns_domain_name.this.id
  domain_name    = civo_dns_domain_name.this.name
  lb_public_ip   = data.civo_loadbalancer.traefik.public_ip
  namespace      = each.key
  namespace_apps = each.value

  depends_on = [
    module.keycloak,
    module.kube_prometheus_stack,
    module.vault,
    module.jenkins,
    module.pulp
  ]

  providers = {
    civo = civo
  }
}
