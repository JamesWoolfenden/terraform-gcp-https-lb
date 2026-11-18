resource "google_compute_managed_ssl_certificate" "main" {
  count = local.use_managed_certificate ? 1 : 0

  name        = "${var.name}-cert"
  description = "Google-managed certificate for ${join(", ", var.managed_ssl_domains)}"

  managed {
    domains = var.managed_ssl_domains
  }

  lifecycle {
    create_before_destroy = true
  }
}
