data "cloudflare_accounts" "root" {
  name = var.account_name
}

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
  value    = var.cloudflare_mx_ip_0
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_1" {
  name     = var.domain_name
  priority = 50
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_ip_1
  zone_id  = cloudflare_zone.root.id
}

resource "cloudflare_record" "cloudflare_mailserver_2" {
  name     = var.domain_name
  priority = 47
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = var.cloudflare_mx_ip_2
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

module "myprivatemodule" {
  source = "git@github.com:meysam81/sample-private-terraform-module.git//?ref=main"
}

output "myoutput" {
  value = module.myprivatemodule.lucky_number
}
