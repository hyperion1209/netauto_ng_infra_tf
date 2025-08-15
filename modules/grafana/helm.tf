locals {
  prometheus_url = "http://${var.prometheus_ip}:${var.prometheus_port}"
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
      prometheus_url = local.prometheus_url
      admin_password = "admin"
    })
  ]
}
