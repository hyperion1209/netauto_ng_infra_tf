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
    keycloak               = true
    vault                  = true
    vault-secrets-operator = true
    kube-prometheus-stack  = true
    pulp                   = true
    jenkins                = true

  }
  ingress_services = {
    keycloak = {
      keycloak = {
        "/" = {
          port         = 80
          service_name = "keycloak-keycloakx-http"
        }
      }
    }
    kube-prometheus-stack = {
      grafana = {
        "/" = {
          port         = 80
          service_name = "kube-prometheus-stack-grafana"
        }
      }
    }
    vault = {
      vault = {
        "/" = {
          port         = 8200
          service_name = "vault"
        }
      }
    }
    jenkins = {
      jenkins = {
        "/" = {
          port         = 8080
          service_name = "jenkins"
        }
      }
    }
    pulp = {
      pulp = {
        "/pulp/api/v3/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
        "/auth/login/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
        "/pulp_ansible/galaxy/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
        "/v2/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
        "/extensions/v2/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
        "/token/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
        "/pypi/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
        "/pulp/content/" = {
          port         = 24816
          service_name = "pulp-content-svc"
        }
        "/pulp/container/" = {
          port         = 24816
          service_name = "pulp-content-svc"
        }
        "/" = {
          port         = 24817
          service_name = "pulp-api-svc"
        }
      }
    }
  }
  # This creates the namespace for the service too
  vso_client_services = {
    grafana = {
      namespace = "kube-prometheus-stack"
      secrets   = ["keycloak-oauth"]
    }
    jenkins = {
      namespace = "jenkins"
      secrets   = ["keycloak-oauth"]
    }
    pulp = {
      namespace = "pulp"
      secrets   = ["keycloak-oauth", "admin"]
    }
  }
}

data "civo_loadbalancer" "traefik" {
  name   = "${local.k8s_cluster.name}-kube-system-traefik"
  region = local.region
}
