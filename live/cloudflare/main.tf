data "cloudflare_accounts" "root" {
  name = var.account_name
}

####################
# meysam.io
####################

resource "cloudflare_zone" "root" {
  account_id = data.cloudflare_accounts.root.accounts[0].id
  paused     = false
  plan       = var.cloudflare_zone_plan
  type       = var.cloudflare_zone_type
  zone       = var.domain_name
}

resource "cloudflare_record" "medium_0" {
  name    = var.domain_name
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = var.medium_ip_0
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "medium_1" {
  name    = var.domain_name
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = var.medium_ip_1
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "medium_2" {
  name    = "www"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = var.medium_ip_0
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "medium_3" {
  name    = "www"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = var.medium_ip_1
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_0" {
  name     = var.domain_name
  priority = 76
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_0
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_1" {
  name     = var.domain_name
  priority = 50
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_1
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_2" {
  name     = var.domain_name
  priority = 47
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_2
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_txt" {
  name    = var.domain_name
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = var.cloudflare_txt_record
  zone_id = cloudflare_zone.root.id
}

####################
# developer-friendly.com
####################

resource "cloudflare_zone" "developer_friendly" {
  account_id = data.cloudflare_accounts.root.accounts[0].id
  paused     = false
  plan       = var.cloudflare_zone_plan
  type       = var.cloudflare_zone_type
  zone       = var.developer_friendly_domain_name
}

resource "cloudflare_record" "dev_blog_mailserver_0" {
  name     = var.developer_friendly_domain_name
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_0
  zone_id  = cloudflare_zone.developer_friendly.id
}

resource "cloudflare_record" "dev_blog_mailserver_1" {
  name     = var.developer_friendly_domain_name
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_1
  zone_id  = cloudflare_zone.developer_friendly.id
}

resource "cloudflare_record" "dev_blog_mailserver_2" {
  name     = var.developer_friendly_domain_name
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_2
  zone_id  = cloudflare_zone.developer_friendly.id
}

resource "cloudflare_record" "dev_blog_dmarc" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = var.cloudflare_dmarc_record
}

resource "cloudflare_record" "dev_blog_substack" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "@"
  proxied = false
  ttl     = 60
  type    = "CNAME"
  value   = "target.substack-custom-domains.com"
}

resource "cloudflare_record" "maileroo_spf_record" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "mailing"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = var.maileroo_spf_record
}

resource "cloudflare_record" "maileroo_dkim_record" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "mta._domainkey.mailing"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = var.maileroo_dkim_record
}

resource "cloudflare_record" "maileroo_mx_0" {
  zone_id  = cloudflare_zone.developer_friendly.id
  name     = "mailing"
  proxied  = false
  priority = 10
  ttl      = 1
  type     = "MX"
  value    = "mx1.maileroo.com"
}

resource "cloudflare_record" "maileroo_mx_1" {
  zone_id  = cloudflare_zone.developer_friendly.id
  name     = "mailing"
  proxied  = false
  priority = 20
  ttl      = 1
  type     = "MX"
  value    = "mx2.maileroo.com"
}

resource "cloudflare_record" "maileroo_dmarc_record" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "_dmarc.mailing"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = var.maileroo_dmarc_record
}

resource "cloudflare_record" "google_search_console" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "google-site-verification"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "II0pZhJHA4p7hBDBQFrDALusl7XsRM1C0KU0hsqnGh0"
}
