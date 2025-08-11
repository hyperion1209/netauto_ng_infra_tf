resource "kubernetes_manifest" "grafana" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "grafana"
      "namespace" = "default"
    }
    "spec" = {
      "commonName" = "grafana.${var.domain}"
      "dnsNames" = [
        "grafana.${var.domain}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "letsencrypt-{terraform.workspace}"
      }
      "secretName" = "grafana"
    }
  }
}

