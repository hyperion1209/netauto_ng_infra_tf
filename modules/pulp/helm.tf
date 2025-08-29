resource "helm_release" "pulp" {
  name             = "pulp"
  repository       = "https://github.com/pulp/pulp-k8s-resources/raw/main/helm-charts"
  chart            = "pulp-operator"
  version          = "0.3.0"
  namespace        = "pulp"
  create_namespace = false

  values = [
    templatefile("${path.module}/values.tftpl", {
    })
  ]
}
