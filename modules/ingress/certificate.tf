resource "kubernetes_manifest" "service_cert" {
  for_each = var.namespace_apps
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = each.key
      "namespace" = var.namespace
    }
    "spec" = {
      "commonName" = "${each.key}.${var.domain_name}"
      "dnsNames" = [
        "${each.key}.${var.domain_name}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "letsencrypt-${terraform.workspace}"
      }
      "secretName" = each.key
    }
  }
  depends_on = [civo_dns_domain_record.this]
}
