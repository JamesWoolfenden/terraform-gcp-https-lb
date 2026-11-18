# Explicit replacement for the deleted default route: only private.googleapis.com is reachable.
# Load balancer proxies and health checks reach the backends over Google's special return paths.
resource "google_compute_route" "google_apis" {
  name             = "lb-web-private-googleapis"
  network          = google_compute_network.web.id
  dest_range       = "199.36.153.8/30"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}
