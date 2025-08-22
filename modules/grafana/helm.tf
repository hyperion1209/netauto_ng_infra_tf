locals {
  prometheus_url = "http://${var.prometheus_attrs.ip}:${var.prometheus_attrs.port}"
  keycloak_url   = "http://keycloak.${var.domain_name}"
  grafana_url    = "https://grafana.${var.domain_name}"
}

resource "kubernetes_secret_v1" "keycloak_secret" {
  metadata {
    name      = "keycloak-oauth-secret"
    namespace = "grafana"
  }
  data = {
    "client_secret" = var.keycloak_creds
  }
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "9.3.1"
  namespace        = "grafana"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tftpl", {
      prometheus_url       = local.prometheus_url
      grafana_url          = local.grafana_url
      keycloak_url         = local.keycloak_url
      custom_dashboards    = fileset("${path.module}/custom_dashboards/", "*.json")
      module_path          = path.module
      storage_class_name   = var.storage_class_name
      keycloak_secret_name = kubernetes_secret_v1.keycloak_secret.metadata[0].name
    })
  ]
}

data "kubernetes_service_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "grafana"
  }
  depends_on = [helm_release.grafana]
}
