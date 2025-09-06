resource "kubernetes_manifest" "configmap_settings" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "analytics"            = "False"
      "token_server"         = "\"https://pulp.netauto-ng-dev.org/token/\""
      "content_origin"       = "\"https://pulp.netauto-ng-dev.org\""
      "ansible_api_hostname" = "\"https://pulp.netauto-ng-dev.org\""
      "pypi_api_hostname"    = "\"https://pulp.netauto-ng-dev.org\""
      "api_root"             = "\"/pulp/\""
      "allowed_export_paths" = "[ \"/tmp\" ]"
      "allowed_import_paths" = "[ \"/tmp\" ]"
      # "authentication_backends" = [
      #   "social_core.backends.keycloak.KeycloakOAuth2",
      # ]
      # "installed_apps" = [
      #   "social_django",
      # ]
      # "social_auth_pipeline" = [
      #   "social_core.pipeline.social_auth.social_details",
      #   "social_core.pipeline.social_auth.social_uid",
      #   "social_core.pipeline.social_auth.social_user",
      #   "social_core.pipeline.user.get_username",
      #   "social_core.pipeline.social_auth.associate_by_email",
      #   "social_core.pipeline.user.create_user",
      #   "social_core.pipeline.social_auth.associate_user",
      #   "social_core.pipeline.social_auth.load_extra_data",
      #   "social_core.pipeline.user.user_details",
      # ]
      # "social_auth_keycloak_authorization_url" = "https://keycloak.netauto-ng-dev.org/auth/realms/netauto-ng/protocol/openid-connect/auth/"
      # "templates" = [
      #   {
      #     "options" = {
      #       "context_processors" = [
      #         "social_django.context_processors.backends",
      #         "social_django.context_processors.login_redirect",
      #       ]
      #     }
      #   },
      # ]
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "name"      = "settings"
      "namespace" = "pulp"
    }
  }
}

resource "kubernetes_manifest" "pulp" {
  manifest = {
    "apiVersion" = "repo-manager.pulpproject.org/v1"
    "kind"       = "Pulp"
    "metadata" = {
      "name"      = "pulp"
      "namespace" = "pulp"
    }
    "spec" = {
      "admin_password_secret" = "admin"
      "image"                 = "pulp/pulp"
      # "env" = [
      #   {
      #     "name" = "SOCIAL_AUTH_KEYCLOAK_KEY"
      #     "valueFrom" = {
      #       "secretKeyRef" = {
      #         "key" = "client_id"
      #         "name" = "keycloak-oauth"
      #       }
      #     }
      #   },
      #   {
      #     "name" = "SOCIAL_AUTH_KEYCLOAK_SECRET"
      #     "valueFrom" = {
      #       "secretKeyRef" = {
      #         "key" = "client_secret"
      #         "name" = "keycloak-oauth"
      #       }
      #     }
      #   },
      # ]
      "api" = {
        "replicas" = 1
      }
      "cache" = {
        "enabled"             = true
        "redis_storage_class" = var.storage_class_name
      }
      "content" = {
        "replicas" = 1
      }
      "custom_pulp_settings" = "settings"
      "database" = {
        "postgres_storage_class" = var.storage_class_name
      }
      "file_storage_access_mode"   = "ReadWriteOnce"
      "file_storage_size"          = "10Gi"
      "file_storage_storage_class" = var.storage_class_name
      "worker" = {
        "replicas" = 1
      }
      # "telemetry" = {
      #   "enabled": true
      # }
    }
  }
}

