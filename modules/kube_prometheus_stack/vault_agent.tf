resource "kubernetes_config_map_v1" "vault_agent_config" {
  metadata {
    name = "vault-agent-config"
    namespace = local.namespace
  }

  data = {
    "vault-agent-config.hcl" = "${file("${path.module}/vault-agent-config.hcl")}"
  }
}

resource "kubernetes_manifest" "servicemonitor_vault" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind" = "ServiceMonitor"
    "metadata" = {
      "name" = "vault"
      "namespace" = "kube-prometheus-stack"
      "labels" = {
        "release" = "kube-prometheus-stack"
      }
    }
    "spec" = {
      "endpoints" = [
        {
          "bearerTokenFile" = "/etc/prometheus/config_out/.vault-token"
          "interval" = "30s"
          "params" = {
            "format" = [
              "prometheus",
            ]
          }
          "path" = "/v1/sys/metrics"
          "port" = "http"
          "scheme" = "http"
          "scrapeTimeout" = "30s"
          "tlsConfig" = {
            "insecureSkipVerify": "true"
          }

        },
      ]
      "namespaceSelector" = {
        "matchNames" = [
          "vault",
        ]
      }
      "selector" = {
        "matchLabels" = {
          "app.kubernetes.io/instance" = "vault"
          "app.kubernetes.io/name" = "vault"
          "vault-internal" = "true"
        }
      }
    }
  }
}

