resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "27.29.0"
  namespace        = "prometheus"
  create_namespace = true

  set = [
    {
      name = "server.persistentVolume.storageClass"
      value = "civo-volume"
    },
    {
      name = "alertmanager.persistence.storageClass"
      value = "civo-volume"
    }
  ]
}

