resource "google_compute_target_https_proxy" "main" {
  name             = "${var.name}-https"
  description      = "HTTPS proxy for ${var.name}"
  url_map          = google_compute_url_map.https.id
  ssl_policy       = google_compute_ssl_policy.main.id
  ssl_certificates = local.ssl_certificates
  certificate_map  = var.certificate_map

  # 0-RTT early data is replayable; keep it off.
  tls_early_data = "DISABLED"
}
