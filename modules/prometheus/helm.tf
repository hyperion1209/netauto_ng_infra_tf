resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "27.29.0"
  namespace        = "prometheus"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tpl", {
      storage_class_name = var.storage_class_name
    })
  ]
}

data "kubernetes_service_v1" "prometheus" {
  metadata {
    name      = "prometheus-server"
    namespace = "prometheus"
  }
  depends_on = [ helm_release.prometheus ]
}
