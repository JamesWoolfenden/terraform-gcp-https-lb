output "ip_address" {
  value       = google_compute_global_address.main.address
  description = "Public IPv4 address of the load balancer; point DNS A records here"
}

output "backend_service_id" {
  value       = google_compute_backend_service.main.id
  description = "ID of the backend service"
}

output "url_map_id" {
  value       = google_compute_url_map.https.id
  description = "ID of the HTTPS URL map"
}

output "https_proxy_id" {
  value       = google_compute_target_https_proxy.main.id
  description = "ID of the target HTTPS proxy"
}

output "ssl_policy_id" {
  value       = google_compute_ssl_policy.main.id
  description = "ID of the SSL policy"
}

output "managed_certificate_id" {
  value       = one(google_compute_managed_ssl_certificate.main[*].id)
  description = "ID of the Google-managed compute certificate (null when a certificate map is used)"
}

output "https_forwarding_rule_id" {
  value       = google_compute_global_forwarding_rule.https.id
  description = "ID of the HTTPS (443) forwarding rule"
}
