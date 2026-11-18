# holden:ignore:HLD_TF_004
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.31.0"
    }
  }
  required_version = ">= 1.9.0" # cross-variable validation (var.managed_ssl_domains referenced from var.certificate_map's validation) requires 1.9+
}
