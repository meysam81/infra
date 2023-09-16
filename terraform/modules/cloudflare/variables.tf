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

variable "medium_ip_0" {
  type    = string
  default = "162.159.153.4"
}

variable "medium_ip_1" {
  type    = string
  default = "162.159.152.4"
}

variable "cloudflare_mx_ip_0" {
  type    = string
  default = "route1.mx.cloudflare.net"
}

variable "cloudflare_mx_ip_1" {
  type    = string
  default = "route2.mx.cloudflare.net"
}

variable "cloudflare_mx_ip_2" {
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
