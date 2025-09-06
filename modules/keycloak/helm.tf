resource "helm_release" "keycloak" {
  name             = "keycloak"
  repository       = "oci://ghcr.io/codecentric/helm-charts/"
  chart            = "keycloakx"
  version          = "7.1.3"
  namespace        = "keycloak"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.tftpl", {
      hostname           = local.hostname
      cluster_issuer     = local.cluster_issuer
      secret_name        = local.service_name
      storage_class_name = var.storage_class_name
    })
  ]
  timeout = 600
}

data "kubernetes_service_v1" "keycloak" {
  metadata {
    name      = "keycloak-keycloakx-http"
    namespace = "keycloak"
  }
  depends_on = [helm_release.keycloak]
}
