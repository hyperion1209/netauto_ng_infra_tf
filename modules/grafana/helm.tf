data "kubernetes_service_v1" "prometheus" {
  metadata {
    name = "prometheus-server"
    namespace = "prometheus"
  }
}

locals {
  prometheus_url = "http://${data.kubernetes_service_v1.prometheus.spec.0.cluster_ip}:${data.kubernetes_service_v1.prometheus.spec.0.port.0.port}"
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "9.3.1"
  namespace        = "grafana"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tpl", {
      prometheus_url         = local.prometheus_url
    })
  ]
}

