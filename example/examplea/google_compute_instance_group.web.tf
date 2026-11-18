# Unmanaged instance group: just enough to give the load balancer a backend with a named HTTPS port.
resource "google_compute_instance_group" "web" {
  name        = "lb-web"
  description = "Web backends for the example load balancer"
  zone        = "europe-west2-a"
  network     = google_compute_network.web.id

  named_port {
    name = "https"
    port = 443
  }
}
