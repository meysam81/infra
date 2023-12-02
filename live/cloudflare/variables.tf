variable "domain_name" {
  type        = string
  description = "The domain name to be used for the Cloudflare DNS zone."
  default     = "meysam.io"
}

variable "cloudflare_api_token" {
  type      = string
  default   = ""
  sensitive = true
}

variable "account_name" {
  type    = string
  default = "Meysam"
}

variable "medium_ip_0" {
  type    = string
  default = "162.159.153.4"
}

variable "medium_ip_1" {
  type    = string
  default = "162.159.152.4"
}

variable "cloudflare_mx_0" {
  type    = string
  default = "route1.mx.cloudflare.net"
}

variable "cloudflare_mx_1" {
  type    = string
  default = "route2.mx.cloudflare.net"
}

variable "cloudflare_mx_2" {
  type    = string
  default = "route3.mx.cloudflare.net"
}

variable "cloudflare_zone_plan" {
  type    = string
  default = "free"
}

variable "cloudflare_zone_type" {
  type    = string
  default = "full"
}

variable "cloudflare_txt_record" {
  type    = string
  default = "v=spf1 include:_spf.mx.cloudflare.net ~all"
}

variable "developer_friendly_domain_name" {
  type    = string
  default = "developer-friendly.com"
}

variable "dev_blog_source_email" {
  type    = string
  default = "hi@developer-friendly.com"
}
variable "dev_blog_target_email" {
  type    = string
  default = "meysamazad81@gmail.com"
}

variable "cloudflare_dmarc_record" {
  type    = string
  default = "v=DMARC1; p=none; rua=mailto:7791bc4d4a21451faf803795caac660e@dmarc-reports.cloudflare.net;"
}
