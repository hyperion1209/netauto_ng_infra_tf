terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "hyperion_home"

    workspaces {
      prefix = "netauto-ng-infra-"
    }
  }
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
  }
  required_version = "~> 1.3"
}
