locals {
  project_name         = "netauto-ng-infra"
  region               = "FRA1"
  permanent_workspaces = ["dev", "prod"]
  profile              = contains(local.permanent_workspaces, terraform.workspace) ? terraform.workspace : "dev"
  namespace            = lower(join("-", [local.project_name, terraform.workspace]))
  domains = {
    dev = "netauto-ng-dev.org"
    prod = "netauto-ng.org"
  }
  cluster_name         = "netauto-ng-dev-cluster"
}

data "civo_loadbalancer" "traefik" {
  name   = "netauto-ng-dev-cluster-kube-system-traefik"
  region = local.region
}
