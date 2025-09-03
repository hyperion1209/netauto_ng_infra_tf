resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "oci://ghcr.io/jenkinsci/helm-charts"
  chart            = "jenkins"
  version          = "5.8.83"
  namespace        = "jenkins"
  create_namespace = false

  values = [
    templatefile("${path.module}/values.tftpl", {
      storage_class_name = var.storage_class_name
    })
  ]
}
