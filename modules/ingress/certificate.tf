resource "kubernetes_manifest" "service_cert" {
  count = var.service_attrs.native_ingress ? 0 : 1
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = var.service_name
      "namespace" = var.service_name
    }
    "spec" = {
      "commonName" = "${var.service_name}.${var.domain_name}"
      "dnsNames" = [
        "${var.service_name}.${var.domain_name}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "letsencrypt-${terraform.workspace}"
      }
      "secretName" = var.service_name
    }
  }
  depends_on = [civo_dns_domain_record.this]
}
