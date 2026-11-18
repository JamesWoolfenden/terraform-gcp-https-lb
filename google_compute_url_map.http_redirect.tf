resource "google_compute_url_map" "http_redirect" {
  name        = "${var.name}-http-redirect"
  description = "Redirects all plain-HTTP traffic for ${var.name} to HTTPS"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}
