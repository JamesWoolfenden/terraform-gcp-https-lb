resource "google_compute_target_http_proxy" "redirect" {
  name        = "${var.name}-http-redirect"
  description = "HTTP proxy for ${var.name} that only issues redirects to HTTPS"
  url_map     = google_compute_url_map.http_redirect.id
}
