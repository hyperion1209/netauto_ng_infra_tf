resource "kubernetes_service_account_v1" "vso" {
  metadata {
    name      = "vault-secrets-operator"
    namespace = "vault-secrets-operator"
  }
}

resource "kubernetes_namespace_v1" "this" {
  for_each = var.clients
  metadata {
    name = each.value.namespace
    labels = {
      "kubernetes.io/metadata.name" = each.value.namespace
      name                          = each.value.namespace
    }
  }
}

resource "kubernetes_service_account_v1" "this" {
  for_each = var.clients
  metadata {
    name      = "vso-vault-access"
    namespace = kubernetes_namespace_v1.this[each.key].id
  }
}

resource "kubernetes_manifest" "vso_client_auth" {
  for_each   = var.clients
  depends_on = [kubernetes_namespace_v1.this]
  manifest = {
    "apiVersion" = "secrets.hashicorp.com/v1beta1"
    "kind"       = "VaultAuth"
    "metadata" = {
      "name"      = "vso-static-auth"
      "namespace" = each.value.namespace
    }
    "spec" = {
      "kubernetes" = {
        "audiences" = [
          "vault",
        ]
        "role"           = "VSO"
        "serviceAccount" = kubernetes_service_account_v1.this[each.key].metadata[0].name
      }
      "method" = "kubernetes"
      "mount"  = "vso"
    }
  }
}

module "client_secrets" {
  depends_on = [kubernetes_manifest.vso_client_auth]
  for_each   = var.clients
  source     = "./client_secrets"
  client_id  = each.key
  namespace  = each.value.namespace
  secrets    = each.value.secrets
}
