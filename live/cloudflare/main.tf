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

resource "cloudflare_record" "dev_blog_txt" {
  name    = var.developer_friendly_domain_name
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = var.cloudflare_txt_record
  zone_id = cloudflare_zone.developer_friendly.id
}

# resource "cloudflare_email_routing_settings" "dev_blog_email" {
#   zone_id = cloudflare_zone.developer_friendly.id
#   enabled = "true"
# }

resource "cloudflare_email_routing_rule" "dev_blog_email_hi" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "Developer Friendly Hi"
  enabled = true

  matcher {
    type  = "literal"
    field = "to"
    value = var.dev_blog_source_email
  }

  action {
    type  = "forward"
    value = [var.dev_blog_target_email]
  }
}

resource "cloudflare_record" "dev_blog_dmarc" {
  zone_id = cloudflare_zone.developer_friendly.id
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = var.cloudflare_dmarc_record
}
