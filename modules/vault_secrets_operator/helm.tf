resource "helm_release" "vso" {
  name             = "vault-secrets-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  version          = "0.10.0"
  namespace        = "vault-secrets-operator"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tftpl", {
    })
  ]
}
