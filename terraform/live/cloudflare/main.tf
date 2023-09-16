provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_accounts" "root" {
  name = var.account_name
}

resource "cloudflare_zone" "root" {
  account_id = data.cloudflare_accounts.root.accounts[0].id
  paused     = false
  plan       = "free"
  type       = "full"
  zone       = var.domain_name
}

resource "cloudflare_record" "medium_0" {
  name    = var.domain_name
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "162.159.153.4"
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "medium_1" {
  name    = var.domain_name
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "162.159.152.4"
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "medium_2" {
  name    = "www"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "162.159.153.4"
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "medium_3" {
  name    = "www"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "162.159.152.4"
  zone_id = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_0" {
  name     = var.domain_name
  priority = 76
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "route1.mx.cloudflare.net"
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_1" {
  name     = var.domain_name
  priority = 50
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "route2.mx.cloudflare.net"
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_2" {
  name     = var.domain_name
  priority = 47
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "route3.mx.cloudflare.net"
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "terraform_managed_resource_56a9eb37185757bb59b04adecd154274" {
  name    = var.domain_name
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  zone_id = cloudflare_zone.root.id
}

