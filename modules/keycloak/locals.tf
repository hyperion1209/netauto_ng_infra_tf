locals {
  service_name   = "keycloak"
  hostname       = "${local.service_name}.${var.domain_name}"
  cluster_issuer = "letsencrypt-${terraform.workspace}"
}
