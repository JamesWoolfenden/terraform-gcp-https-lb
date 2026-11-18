variable "name" {
  type        = string
  description = "Name prefix for every load balancer resource"

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,45}[a-z0-9])?$", var.name))
    error_message = "var.name must be a valid GCP resource name: lowercase letters, digits and hyphens, starting with a letter, at most 47 characters (leaves room for suffixes such as -http-redirect)"
  }
}

variable "backends" {
  type        = list(string)
  description = "Self links of the instance groups or network endpoint groups that serve traffic"

  validation {
    condition     = length(var.backends) > 0 && alltrue([for b in var.backends : can(regex("/(instanceGroups|networkEndpointGroups)/[^/]+$", b))])
    error_message = "var.backends must contain at least one instance group or network endpoint group self link/ID"
  }
}

variable "serverless_backends" {
  type        = bool
  description = "Set true when var.backends are serverless NEGs (Cloud Run, Cloud Functions, App Engine): no health check, named port or backend timeout is configured"
  default     = false

  validation {
    condition     = !var.serverless_backends || alltrue([for b in var.backends : can(regex("/networkEndpointGroups/", b))])
    error_message = "var.serverless_backends can only be true when every entry in var.backends is a network endpoint group"
  }
}

variable "security_policy" {
  type        = string
  description = "Self link or ID of the Cloud Armor security policy attached to the backend service"

  validation {
    condition     = can(regex("/securityPolicies/[^/]+$", var.security_policy))
    error_message = "var.security_policy must be a Cloud Armor security policy self link or ID (.../securityPolicies/NAME)"
  }
}

variable "managed_ssl_domains" {
  type        = list(string)
  description = "Domains for the Google-managed compute SSL certificate. Used when var.certificate_map is null"
  default     = []

  validation {
    condition     = alltrue([for d in var.managed_ssl_domains : can(regex("^([a-z0-9]([-a-z0-9]*[a-z0-9])?\\.)+[a-z]{2,63}\\.?$", d))])
    error_message = "var.managed_ssl_domains entries must be fully qualified, lowercase domain names (no wildcards: Google-managed compute certificates do not support them)"
  }
}

variable "certificate_map" {
  type        = string
  description = "Certificate Manager certificate map, as //certificatemanager.googleapis.com/projects/P/locations/global/certificateMaps/NAME. When set, no compute managed certificate is created"
  default     = null

  validation {
    condition     = var.certificate_map == null || can(regex("^//certificatemanager\\.googleapis\\.com/projects/[^/]+/locations/global/certificateMaps/[^/]+$", var.certificate_map))
    error_message = "var.certificate_map must be of the form //certificatemanager.googleapis.com/projects/P/locations/global/certificateMaps/NAME"
  }

  validation {
    condition     = (var.certificate_map == null) != (length(var.managed_ssl_domains) == 0)
    error_message = "Set exactly one of var.certificate_map or var.managed_ssl_domains"
  }
}

variable "ssl_profile" {
  type        = string
  description = "SSL policy profile: MODERN or RESTRICTED (COMPATIBLE and CUSTOM are not allowed)"
  default     = "MODERN"

  validation {
    condition     = contains(["MODERN", "RESTRICTED"], var.ssl_profile)
    error_message = "var.ssl_profile must be one of MODERN or RESTRICTED"
  }
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version accepted by the load balancer: TLS_1_2 or TLS_1_3"
  default     = "TLS_1_2"

  validation {
    condition     = contains(["TLS_1_2", "TLS_1_3"], var.min_tls_version)
    error_message = "var.min_tls_version must be one of TLS_1_2 or TLS_1_3"
  }
}

variable "port_name" {
  type        = string
  description = "Named port on the instance groups that serves HTTPS; ignored for serverless backends"
  default     = "https"

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.port_name))
    error_message = "var.port_name must be a valid named port (RFC1035)"
  }
}

variable "timeout_sec" {
  type        = number
  description = "Backend response timeout in seconds; ignored for serverless backends"
  default     = 30

  validation {
    condition     = var.timeout_sec >= 1 && var.timeout_sec <= 86400
    error_message = "var.timeout_sec must be between 1 and 86400"
  }
}

variable "connection_draining_timeout_sec" {
  type        = number
  description = "Seconds to let in-flight requests finish when a backend is removed"
  default     = 300

  validation {
    condition     = var.connection_draining_timeout_sec >= 0 && var.connection_draining_timeout_sec <= 3600
    error_message = "var.connection_draining_timeout_sec must be between 0 and 3600"
  }
}

variable "health_check" {
  type = object({
    request_path        = optional(string, "/")
    check_interval_sec  = optional(number, 10)
    timeout_sec         = optional(number, 5)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 3)
  })
  description = "HTTPS health check settings for non-serverless backends"
  default     = {}

  validation {
    condition     = startswith(var.health_check.request_path, "/") && var.health_check.timeout_sec <= var.health_check.check_interval_sec
    error_message = "var.health_check.request_path must start with / and timeout_sec must not exceed check_interval_sec"
  }
}

variable "log_sample_rate" {
  type        = number
  description = "Fraction of requests logged by the backend service (0 < rate <= 1). Logging itself is always enabled"
  default     = 1

  validation {
    condition     = var.log_sample_rate > 0 && var.log_sample_rate <= 1
    error_message = "var.log_sample_rate must be greater than 0 and at most 1"
  }
}

variable "custom_response_headers" {
  type        = list(string)
  description = "Headers added to every response, as \"Name: value\". Defaults to HSTS"
  default     = ["Strict-Transport-Security: max-age=31536000; includeSubDomains"]

  validation {
    condition     = alltrue([for h in var.custom_response_headers : can(regex("^[A-Za-z0-9-]+: .+$", h))])
    error_message = "var.custom_response_headers entries must be of the form \"Name: value\""
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the global address and forwarding rules, for cost allocation and ownership tracking"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", k)) && can(regex("^[a-z0-9_-]{0,63}$", v))])
    error_message = "var.labels keys and values must be lowercase alphanumerics, underscores, or hyphens, 1-63 characters (GCP label constraints)"
  }
}
