resource "google_compute_url_map" "https" {
  name            = "${var.name}-https"
  description     = "Routes all HTTPS traffic for ${var.name} to its backend service"
  default_service = google_compute_backend_service.main.id
}
