resource "google_compute_global_forwarding_rule" "https" {
  name                  = "${var.name}-https"
  description           = "HTTPS (443) entry point for ${var.name}"
  ip_address            = google_compute_global_address.main.id
  ip_protocol           = "TCP"
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_https_proxy.main.id
  labels                = var.labels
}
