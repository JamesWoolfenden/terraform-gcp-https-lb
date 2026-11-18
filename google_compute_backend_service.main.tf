resource "google_compute_backend_service" "main" {
  name                  = "${var.name}-backend"
  description           = "Backend service for the ${var.name} external Application Load Balancer"
  protocol              = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_name             = local.port_name
  timeout_sec           = local.timeout_sec
  health_checks         = local.health_checks
  security_policy       = var.security_policy
  enable_cdn            = false

  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  custom_response_headers         = var.custom_response_headers

  dynamic "backend" {
    for_each = toset(var.backends)
    content {
      group = backend.value
    }
  }

  log_config {
    enable      = true
    sample_rate = var.log_sample_rate
  }
}
