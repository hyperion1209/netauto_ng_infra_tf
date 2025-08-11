terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = "1.1.5"
    }
  }
}

provider "civo" {
  region = var.region
}
