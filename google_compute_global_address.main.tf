resource "google_compute_global_address" "main" {
  name         = "${var.name}-ip"
  description  = "Anycast IPv4 address for the ${var.name} external Application Load Balancer"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
  labels       = var.labels

  # DNS records point at this address; losing it means re-pointing every record.
  lifecycle {
    prevent_destroy = true
  }
}
