resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "9.3.1"
  namespace        = "grafana"
  create_namespace = true

  set = [
    {
      name  = "persistence.enabled"
      value = "true"
    },
    {
      name  = "persistence.storageClassName"
      value = "civo-volume"
    }
  ]
}

