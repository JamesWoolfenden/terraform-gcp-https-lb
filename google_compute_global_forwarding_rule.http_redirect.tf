# holden:ignore:HLD_GCP_106 — this proxy's URL map has only a default_url_redirect with
# https_redirect = true (301): no request is ever served or proxied to a backend over plain HTTP.
resource "google_compute_global_forwarding_rule" "http_redirect" {
  name                  = "${var.name}-http-redirect"
  description           = "HTTP (80) entry point for ${var.name}; redirects to HTTPS only"
  ip_address            = google_compute_global_address.main.id
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_http_proxy.redirect.id
  labels                = var.labels
}
