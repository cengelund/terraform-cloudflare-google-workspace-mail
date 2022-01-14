variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}
variable "sub_domain" {
  default     = "@"
  description = "The sub-domain for the MX records, if applicable (optional)"
  type        = string
}

variable "ttl" {
  default     = 1
  description = "TTL for the DNS records (optional)"
  type        = number
}

variable "dkim_domainkey_prefix" {
  default     = "google"
  description = "Prifix / selector for DKIM TXT Record (optional)"
  type        = string
}
variable "dkim_publickey" {
  description = "DKIM public key"
  type        = string
}
variable "dmarc_rua" {
  type        = list(string)
  description = "Email addresses for DMARC Aggregate reports (excluding `mailto:`)"

  validation {
    condition     = length(var.dmarc_rua) != 0
    error_message = "Must contain at least one email address."
  }

  validation {
    condition     = can([for email in var.dmarc_rua : regex("@", email)])
    error_message = "Must be a valid email address."
  }
}

variable "dmarc_ruf" {
  type        = list(string)
  description = "Email addresses for DMARC Failure (or Forensic) reports (excluding `mailto:`)"

  validation {
    condition     = length(var.dmarc_ruf) != 0
    error_message = "Must contain at least one email address."
  }

  validation {
    condition     = can([for email in var.dmarc_ruf : regex("@", email)])
    error_message = "Must be a valid email address."
  }
}

variable "spf_terms" {
  type        = list(string)
  description = "Additional SPF terms to include, `include:_spf.google.com -all` is already included default"
  default     = []

  validation {
    condition     = can([for term in var.spf_terms : regex("^(\\+|-|\\?|~)?(all|include|a|mx|ip4|ip6|exists)", term)])
    error_message = "SPF term must start with a valid qualifier (optional) or mechanism."
  }
}
