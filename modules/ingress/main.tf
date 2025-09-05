resource "kubernetes_ingress_v1" "service_ingress" {
  depends_on = [kubernetes_manifest.service_cert, civo_dns_domain_record.this]
  metadata {
    name      = var.namespace
    namespace = var.namespace
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-${terraform.workspace}"
      "kubernetes.io/ingress.class"    = "traefik"
    }

  }
  spec {
    dynamic "rule" {
      for_each = var.namespace_apps
      content {
        host = "${rule.key}.${var.domain_name}"
        http {
          dynamic "path" {
            for_each = var.namespace_apps[rule.key]
            content {
              path      = path.key
              path_type = "Prefix"
              backend {
                service {
                  name = path.value.service_name
                  port {
                    number = path.value.port
                  }
                }
              }
            }
          }
        }
      }
    }
    dynamic "tls" {
      for_each = var.namespace_apps
      content {
        hosts = [
          "${tls.key}.${var.domain_name}"
        ]
        secret_name = tls.key
      }

    }
  }

}
