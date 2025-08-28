resource "kubernetes_manifest" "vso_service_account" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "name"      = "vault-secrets-operator"
      "namespace" = "vault-secrets-operator"
    }
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
    name      = "${each.key}-vault-access"
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
      "name"      = "${each.key}-static-auth"
      "namespace" = each.value.namespace
    }
    "spec" = {
      "kubernetes" = {
        "audiences" = [
          "vault",
        ]
        "role"           = "${each.key}-keycloak-secrets"
        "serviceAccount" = kubernetes_service_account_v1.this[each.key].metadata[0].name
      }
      "method" = "kubernetes"
      "mount"  = "keycloak_oauth"
    }
  }
}

resource "kubernetes_manifest" "vault_static_secret" {
  for_each   = var.clients
  depends_on = [kubernetes_manifest.vso_client_auth]
  manifest = {
    "apiVersion" = "secrets.hashicorp.com/v1beta1"
    "kind"       = "VaultStaticSecret"
    "metadata" = {
      "name"      = "keycloak-oauth-creds"
      "namespace" = each.value.namespace
    }
    "spec" = {
      "destination" = {
        "create" = true
        "name"   = "keycloak-oauth-creds"
      }
      "mount"        = "keycloak-oauth-client-secrets"
      "path"         = "${each.key}-oauth"
      "refreshAfter" = "30s"
      "type"         = "kv-v2"
      "vaultAuthRef" = "${each.key}-static-auth"
    }
  }
}

