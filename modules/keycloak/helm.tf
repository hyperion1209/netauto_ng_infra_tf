resource "helm_release" "keycloak" {
  name             = "keycloak"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "keycloak"
  version          = "25.1.0"
  namespace        = "keycloak"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tftpl", {
    })
  ]
}
