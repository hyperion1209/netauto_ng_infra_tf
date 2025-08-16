# prometheus-values.tpl
server:
  persistentVolume:
    enabled: true
    size: 8Gi
    storageClass: ${storage_class_name}
alertmanager:
  persistence:
    enabled: true
    storageClass: ${storage_class_name}
