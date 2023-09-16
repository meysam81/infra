variable "domain_name" {
  type        = string
  description = "The domain name to be used for the Cloudflare DNS zone."
  default     = "meysam.io"
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "account_name" {
  type    = string
  default = "Meysam"
}
