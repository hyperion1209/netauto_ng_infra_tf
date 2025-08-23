resource "kubernetes_namespace_v1" "kube_prometheus_stack" {
  metadata {
    name = local.service_name
    labels = {
      "kubernetes.io/metadata.name" = local.service_name
      name                          = local.service_name
    }
  }
}

resource "kubernetes_secret_v1" "keycloak_secret" {
  metadata {
    name      = "keycloak-oauth-secret"
    namespace = kubernetes_namespace_v1.kube_prometheus_stack.metadata[0].name
  }
  data = {
    "client_secret" = var.keycloak_creds
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "76.5.0"
  namespace        = "kube-prometheus-stack"
  create_namespace = false

  values = [
    templatefile("${path.module}/values.tftpl", {
      grafana_url          = local.grafana_url
      keycloak_url         = local.keycloak_url
      keycloak_secret_name = kubernetes_secret_v1.keycloak_secret.metadata[0].name
      storage_class_name = var.storage_class_name
    })
  ]
}

# data "kubernetes_service_v1" "prometheus" {
#   metadata {
#     name      = "prometheus-server"
#     namespace = "prometheus"
#   }
#   depends_on = [helm_release.prometheus]
# }
