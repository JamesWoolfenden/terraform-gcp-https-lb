resource "google_compute_managed_ssl_certificate" "main" {
  count = local.use_managed_certificate ? 1 : 0

  # The domain hash keeps the name unique per domain set: domains force a
  # replacement, and create_before_destroy needs the new cert's name free.
  name        = "${var.name}-cert-${substr(sha1(join(",", sort(var.managed_ssl_domains))), 0, 8)}"
  description = "Google-managed certificate for ${join(", ", var.managed_ssl_domains)}"

  managed {
    domains = var.managed_ssl_domains
  }

  lifecycle {
    create_before_destroy = true
  }
}
