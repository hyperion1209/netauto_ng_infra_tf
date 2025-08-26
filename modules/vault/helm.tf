resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  version          = "0.30.1"
  namespace        = "vault"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tftpl", {
      storage_class_name = var.storage_class_name
    })
  ]
}
