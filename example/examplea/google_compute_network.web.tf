resource "google_compute_network" "web" {
  name                            = "lb-web"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}
