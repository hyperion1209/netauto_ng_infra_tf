resource "kubernetes_manifest" "service_ingress" {
  depends_on = [kubernetes_manifest.service_cert, civo_dns_domain_record.this]
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "annotations" = {
        "cert-manager.io/cluster-issuer" = "letsencrypt-${terraform.workspace}"
        "kubernetes.io/ingress.class"    = "traefik"
      }
      "name"      = var.service_name
      "namespace" = local.namespace
    }
    "spec" = {
      "rules" = [
        {
          "host" = "${var.service_name}.${var.domain_name}"
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = local.backend_service
                    "port" = {
                      "number" = var.service_attrs.backend.port
                    }
                  }
                }
                "path"     = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
      "tls" = [
        {
          "hosts" = [
            "${var.service_name}.${var.domain_name}"
          ]
          "secretName" = var.service_name
        },
      ]
    }
  }
}
