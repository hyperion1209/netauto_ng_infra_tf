locals {
  region               = "FRA1"
  permanent_workspaces = ["dev", "prod"]
  profile              = contains(local.permanent_workspaces, terraform.workspace) ? terraform.workspace : "dev"
  domains = {
    dev  = "netauto-ng-dev.org"
    prod = "netauto-ng.org"
  }
  k8s_cluster = {
    name               = "netauto-ng-dev-cluster"
    storage_class_name = "civo-volume"
  }
  enabled_services = {
    keycloak   = true
    vault      = false
    prometheus = false
    grafana    = false
    kube_prometheus_stack = true
  }
  ingress_services = {
    keycloak = {
      backend = {
        port    = 80
        service = "keycloak-keycloakx-http"
      }
      native_ingress = false
    }
    # grafana = {
    #   backend = {
    #     port = 80
    #   }
    # }
    # vault = {
    #   backend = {
    #     port    = 8200
    #     service = "vault-ui"
    #   }
    # }
  }
}

data "civo_loadbalancer" "traefik" {
  name   = "${local.k8s_cluster.name}-kube-system-traefik"
  region = local.region
}
