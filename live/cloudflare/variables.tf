variable "domain_name" {
  type        = string
  description = "The domain name to be used for the Cloudflare DNS zone."
  default     = "meysam.io"
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

variable "cloudflare_dmarc_record" {
  type    = string
  default = "v=DMARC1; p=none; rua=mailto:7791bc4d4a21451faf803795caac660e@dmarc-reports.cloudflare.net;"
}

variable "maileroo_spf_record" {
  type    = string
  default = "v=spf1 include:_spf.maileroo.com ~all"
}

variable "maileroo_dkim_record" {
  type    = string
  default = "v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Ws0CRgW34qcbpBAw+7XU8QFdcwSYnnWbqXAuXfpWsr5+84rTonzumQl3uPFEoX12qTGL6v2sW8oLOSVoWmDP1nLxFcRPteQUcKfE/yaqjiXlWa5pAmfbd/d3cW4uyn8WEddCOhEQLG/pEOYfa8gQnap8433la9iqMPPYtQYEdkmzfAM+To6dEgh89VLhsOvtz2FoMTmtNEPwH/QS8fXNRPWtTqZ6cFQSY3DVLwgvxXN943yxzPKojzJT2SUwl9GVg3rne7rC1WmHMjJjSouZKAPHYbzBAYY0p+wq8fTDGpDRKiZi6faMsB6drNuMJrYL8J2FWmZJx2hFEfoUgQv7QIDAQAB"
}

variable "maileroo_dmarc_record" {
  type    = string
  default = "v=DMARC1; p=reject;"
}
