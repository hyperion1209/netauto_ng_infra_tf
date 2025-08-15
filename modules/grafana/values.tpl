# grafana-values.tpl
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        url: ${prometheus_url}
        access: proxy
        isDefault: true
        basicAuth: false
        editable: false
persistence:
  type: pvc
  enabled: true
  storageClassName: civo-volume

# Optional: Enable admin password via variable
# adminPassword: ${admin_password}
