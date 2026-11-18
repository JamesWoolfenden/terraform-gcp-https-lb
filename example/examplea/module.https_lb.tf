# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "https_lb" {
  source              = "../../"
  name                = "example-web"
  backends            = [google_compute_instance_group.web.self_link]
  security_policy     = google_compute_security_policy.edge.self_link
  managed_ssl_domains = ["www.example.com"]
}
