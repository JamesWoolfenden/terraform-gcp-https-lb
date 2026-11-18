resource "google_compute_security_policy" "edge" {
  name        = "lb-edge"
  description = "Cloud Armor policy for the example load balancer"

  rule {
    action      = "deny(403)"
    priority    = 1000
    description = "Block common web attacks (OWASP CRS SQLi/XSS)"
    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sqli-v33-stable') || evaluatePreconfiguredWaf('xss-v33-stable')"
      }
    }
  }

  rule {
    action      = "allow"
    priority    = 2147483647
    description = "Default allow"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}
