locals {
  region               = "FRA1"
  permanent_workspaces = ["dev", "prod"]
  profile              = contains(local.permanent_workspaces, terraform.workspace) ? terraform.workspace : "dev"
  domains = {
    dev  = "netauto-ng-dev.org"
    prod = "netauto-ng.org"
  }
  k8s_cluster = {
    name = "netauto-ng-dev-cluster"
    storage_class_name = "civo-volume"
  }
  enabled_services = {
    prometheus = true
    grafana    = false
  }
  ingress_services = {
    # grafana = 80
  }
}

data "civo_loadbalancer" "traefik" {
  name   = "${local.k8s_cluster.name}-kube-system-traefik"
  region = local.region
}
