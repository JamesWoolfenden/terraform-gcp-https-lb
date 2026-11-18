resource "google_compute_ssl_policy" "main" {
  name            = "${var.name}-ssl-policy"
  description     = "TLS policy for ${var.name}: ${var.ssl_profile} profile, minimum ${var.min_tls_version}"
  profile         = var.ssl_profile
  min_tls_version = var.min_tls_version
}
