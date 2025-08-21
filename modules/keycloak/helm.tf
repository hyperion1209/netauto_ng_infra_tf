resource "helm_release" "keycloak" {
  name             = "keycloak"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  chart            = "keycloak"
  version          = "25.1.0"
  namespace        = "keycloak"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tftpl", {
    })
  ]
  timeout = 600
}

data "kubernetes_service_v1" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "keycloak"
  }
  depends_on = [helm_release.keycloak]
}
