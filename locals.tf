locals {
  # Certificates come either from a Google-managed compute certificate created here
  # or from a Certificate Manager certificate map passed in (see terraform-gcp-certificate-manager).
  use_managed_certificate = var.certificate_map == null

  ssl_certificates = local.use_managed_certificate ? [google_compute_managed_ssl_certificate.main[0].id] : null

  # Serverless NEGs (Cloud Run, Cloud Functions, App Engine) take no health check,
  # named port or backend timeout.
  health_checks = var.serverless_backends ? null : [google_compute_health_check.main[0].id]
  port_name     = var.serverless_backends ? null : var.port_name
  timeout_sec   = var.serverless_backends ? null : var.timeout_sec
}
