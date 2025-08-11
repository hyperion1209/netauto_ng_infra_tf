resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-${terraform.workspace}"
    }
    "spec" = {
      "acme" = {
        "email" = "netauto.ng@gmail.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-${terraform.workspace}"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "traefik"
              }
            }
          },
        ]
      }
    }
  }
}
