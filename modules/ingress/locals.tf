locals {
  namespace = coalesce(var.service_attrs.namespace, var.service_name)
  backend_service = coalesce(var.service_attrs.backend.service, var.service_name)
}
