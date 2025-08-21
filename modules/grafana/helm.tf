locals {
  prometheus_url = "http://${var.prometheus_attrs.ip}:${var.prometheus_attrs.port}"
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
      prometheus_url     = local.prometheus_url
      custom_dashboards  = fileset("${path.module}/custom_dashboards/", "*.json")
      module_path        = path.module
      storage_class_name = var.storage_class_name
      admin_password     = "admin"
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
