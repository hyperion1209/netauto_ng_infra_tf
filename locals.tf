locals {
  project_name         = "netauto-ng-infra"
  region               = "FRA1"
  permanent_workspaces = ["dev", "prod"]
  profile              = contains(local.permanent_workspaces, terraform.workspace) ? terraform.workspace : "dev"
  namespace            = lower(join("-", [local.project_name, terraform.workspace]))
  domains = {
    dev  = "netauto-ng-dev.org"
    prod = "netauto-ng.org"
  }
  cluster_name = "netauto-ng-dev-cluster"
  enabled_services = {
    prometheus = true
    grafana    = true
  }
  ingress_services = {
    grafana = 80
  }
}

data "civo_loadbalancer" "traefik" {
  name   = "${local.cluster_name}-kube-system-traefik"
  region = local.region
}
