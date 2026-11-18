# Only Google Front End / health check ranges may reach the backends, and only on 443.
resource "google_compute_firewall" "allow_lb" {
  name      = "lb-web-allow-gfe"
  network   = google_compute_network.web.id
  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
