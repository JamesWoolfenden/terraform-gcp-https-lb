# terraform-gcp-https-lb

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-https-lb/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-gcp-https-lb/actions)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-https-lb.svg)](https://github.com/JamesWoolfenden/terraform-gcp-https-lb/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-https-lb.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-https-lb/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for a global external Application Load Balancer (`EXTERNAL_MANAGED`). It creates a reserved anycast IP, an HTTPS backend service with request logging and a mandatory Cloud Armor policy, an HTTPS health check (skipped for serverless NEGs), an SSL policy (`MODERN`/`RESTRICTED`, TLS 1.2 minimum), a target HTTPS proxy on 443 using either a Google-managed certificate or a Certificate Manager certificate map, and an HTTP (80) listener that only issues 301 redirects to HTTPS. Backends are passed in as instance group or NEG self links.

## Usage

Add **module.https_lb.tf** to your code:-

```terraform
module "https_lb" {
  source              = "jameswoolfenden/https-lb/gcp"
  name                = "example-web"
  backends            = [google_compute_instance_group.web.self_link]
  security_policy     = google_compute_security_policy.edge.self_link
  managed_ssl_domains = ["www.example.com"]
}
```

See [example/examplea](example/examplea) for a complete working example.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_compute_backend_service.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_address.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.http_redirect](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_health_check.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_managed_ssl_certificate.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) | resource |
| [google_compute_ssl_policy.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |
| [google_compute_target_http_proxy.redirect](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_target_https_proxy.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.http_redirect](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_compute_url_map.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_backends"></a> [backends](#input\_backends) | Self links of the instance groups (or, with var.serverless\_backends, serverless network endpoint groups) that serve traffic | `list(string)` | n/a | yes |
| <a name="input_certificate_map"></a> [certificate\_map](#input\_certificate\_map) | Certificate Manager certificate map, as //certificatemanager.googleapis.com/projects/P/locations/global/certificateMaps/NAME. When set, no compute managed certificate is created | `string` | `null` | no |
| <a name="input_connection_draining_timeout_sec"></a> [connection\_draining\_timeout\_sec](#input\_connection\_draining\_timeout\_sec) | Seconds to let in-flight requests finish when a backend is removed | `number` | `300` | no |
| <a name="input_custom_response_headers"></a> [custom\_response\_headers](#input\_custom\_response\_headers) | Headers added to every response, as "Name: value". Defaults to HSTS | `list(string)` | <pre>[<br/>  "Strict-Transport-Security: max-age=31536000; includeSubDomains"<br/>]</pre> | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | HTTPS health check settings for non-serverless backends | <pre>object({<br/>    request_path        = optional(string, "/")<br/>    check_interval_sec  = optional(number, 10)<br/>    timeout_sec         = optional(number, 5)<br/>    healthy_threshold   = optional(number, 2)<br/>    unhealthy_threshold = optional(number, 3)<br/>  })</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels applied to the global address and forwarding rules, for cost allocation and ownership tracking | `map(string)` | `{}` | no |
| <a name="input_log_sample_rate"></a> [log\_sample\_rate](#input\_log\_sample\_rate) | Fraction of requests logged by the backend service (0 < rate <= 1). Logging itself is always enabled | `number` | `1` | no |
| <a name="input_managed_ssl_domains"></a> [managed\_ssl\_domains](#input\_managed\_ssl\_domains) | Domains for the Google-managed compute SSL certificate. Used when var.certificate\_map is null | `list(string)` | `[]` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | Minimum TLS version accepted by the load balancer: TLS\_1\_2 or TLS\_1\_3 | `string` | `"TLS_1_2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for every load balancer resource | `string` | n/a | yes |
| <a name="input_port_name"></a> [port\_name](#input\_port\_name) | Named port on the instance groups that serves HTTPS; ignored for serverless backends | `string` | `"https"` | no |
| <a name="input_security_policy"></a> [security\_policy](#input\_security\_policy) | Self link or ID of the Cloud Armor security policy attached to the backend service | `string` | n/a | yes |
| <a name="input_serverless_backends"></a> [serverless\_backends](#input\_serverless\_backends) | Set true when var.backends are serverless NEGs (Cloud Run, Cloud Functions, App Engine): no health check, named port or backend timeout is configured. When false, var.backends must be instance groups (the named-port health check does not apply to NEGs) | `bool` | `false` | no |
| <a name="input_ssl_profile"></a> [ssl\_profile](#input\_ssl\_profile) | SSL policy profile: MODERN or RESTRICTED (COMPATIBLE and CUSTOM are not allowed) | `string` | `"MODERN"` | no |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | Backend response timeout in seconds; ignored for serverless backends | `number` | `30` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_service_id"></a> [backend\_service\_id](#output\_backend\_service\_id) | ID of the backend service |
| <a name="output_https_forwarding_rule_id"></a> [https\_forwarding\_rule\_id](#output\_https\_forwarding\_rule\_id) | ID of the HTTPS (443) forwarding rule |
| <a name="output_https_proxy_id"></a> [https\_proxy\_id](#output\_https\_proxy\_id) | ID of the target HTTPS proxy |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | Public IPv4 address of the load balancer; point DNS A records here |
| <a name="output_managed_certificate_id"></a> [managed\_certificate\_id](#output\_managed\_certificate\_id) | ID of the Google-managed compute certificate (null when a certificate map is used) |
| <a name="output_ssl_policy_id"></a> [ssl\_policy\_id](#output\_ssl\_policy\_id) | ID of the SSL policy |
| <a name="output_url_map_id"></a> [url\_map\_id](#output\_url\_map\_id) | ID of the HTTPS URL map |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "compute.backendBuckets.use",
    "compute.backendServices.create",
    "compute.backendServices.delete",
    "compute.backendServices.get",
    "compute.backendServices.update",
    "compute.backendServices.use",
    "compute.globalAddresses.create",
    "compute.globalAddresses.createInternal",
    "compute.globalAddresses.delete",
    "compute.globalAddresses.deleteInternal",
    "compute.globalAddresses.get",
    "compute.globalAddresses.setLabels",
    "compute.globalForwardingRules.create",
    "compute.globalForwardingRules.delete",
    "compute.globalForwardingRules.get",
    "compute.globalForwardingRules.update",
    "compute.globalOperations.get",
    "compute.healthChecks.create",
    "compute.healthChecks.delete",
    "compute.healthChecks.get",
    "compute.healthChecks.update",
    "compute.healthChecks.useReadOnly",
    "compute.httpHealthChecks.useReadOnly",
    "compute.httpsHealthChecks.useReadOnly",
    "compute.networks.use",
    "compute.sslCertificates.create",
    "compute.sslCertificates.delete",
    "compute.sslCertificates.get",
    "compute.sslPolicies.create",
    "compute.sslPolicies.delete",
    "compute.sslPolicies.get",
    "compute.sslPolicies.update",
    "compute.targetHttpProxies.create",
    "compute.targetHttpProxies.delete",
    "compute.targetHttpProxies.get",
    "compute.targetHttpProxies.update",
    "compute.targetHttpsProxies.create",
    "compute.targetHttpsProxies.delete",
    "compute.targetHttpsProxies.get",
    "compute.targetHttpsProxies.update",
    "compute.urlMaps.create",
    "compute.urlMaps.delete",
    "compute.urlMaps.get",
    "compute.urlMaps.update"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "compute.backendServices.get",
    "compute.globalAddresses.get",
    "compute.globalForwardingRules.get",
    "compute.globalOperations.get",
    "compute.healthChecks.get",
    "compute.sslCertificates.get",
    "compute.sslPolicies.get",
    "compute.targetHttpProxies.get",
    "compute.targetHttpsProxies.get",
    "compute.urlMaps.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/jameswoolfenden/terraform-gcp-https-lb/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/jameswoolfenden/terraform-gcp-https-lb/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
