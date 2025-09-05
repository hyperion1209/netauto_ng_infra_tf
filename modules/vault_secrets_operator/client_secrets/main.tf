resource "kubernetes_manifest" "client_oauth_secret" {
  for_each = toset(var.secrets)
  manifest = {
    "apiVersion" = "secrets.hashicorp.com/v1beta1"
    "kind"       = "VaultStaticSecret"
    "metadata" = {
      "name"      = each.value
      "namespace" = var.namespace
    }
    "spec" = {
      "destination" = {
        "create" = true
        "name"   = each.value
      }
      "mount"        = "kv/services/${var.client_id}"
      "path"         = each.value
      "refreshAfter" = "30s"
      "type"         = "kv-v2"
      "vaultAuthRef" = "vso-static-auth"
    }
  }
}
