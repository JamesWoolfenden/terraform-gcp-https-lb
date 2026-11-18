resource "google_compute_health_check" "main" {
  count = var.serverless_backends ? 0 : 1

  name                = "${var.name}-hc"
  description         = "HTTPS health check for the ${var.name} backends"
  check_interval_sec  = var.health_check.check_interval_sec
  timeout_sec         = var.health_check.timeout_sec
  healthy_threshold   = var.health_check.healthy_threshold
  unhealthy_threshold = var.health_check.unhealthy_threshold

  https_health_check {
    port_specification = "USE_NAMED_PORT"
    port_name          = var.port_name
    request_path       = var.health_check.request_path
  }

  log_config {
    enable = true
  }
}
