module "cert_issuer" {
  source = "./modules/cert_issuer"
  lb_public_ip = data.civo_loadbalancer.traefik.public_ip
  domain = local.domains[local.profile]
}

module "prometheus" {
  source = "./modules/prometheus"
  lb_public_ip = data.civo_loadbalancer.traefik.public_ip
  domain = local.domains[local.profile]
}

module "grafana" {
  source = "./modules/grafana"
  lb_public_ip = data.civo_loadbalancer.traefik.public_ip
  domain = local.domains[local.profile]
}
