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
    keycloak              = true
    vault                 = false
    prometheus            = false
    grafana               = false
    kube-prometheus-stack = true
  }
  ingress_services = {
    keycloak = {
      keycloak = {
        port         = 80
        service_name = "keycloak-keycloakx-http"
      }
    }
    kube-prometheus-stack = {
      grafana = {
        port         = 80
        service_name = "kube-prometheus-stack-grafana"
      }
    }
    # grafana = {
    #   grafana = {
    #     port = 80
    #     service_name = "grafana"
    #   }
    # }
    # vault = {
    #   vault = {
    #     port    = 8200
    #     service_name = "vault-ui"
    #   }
    # }
  }
}

data "civo_loadbalancer" "traefik" {
  name   = "${local.k8s_cluster.name}-kube-system-traefik"
  region = local.region
}
