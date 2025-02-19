resource "cloudflare_email_routing_address" "licenseware" {
  account_id = data.cloudflare_accounts.meysam.result[0].id
  email      = "meysam@licenseware.io"
}

resource "cloudflare_email_routing_rule" "lwarebot" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "lwarebot"
  enabled = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = "lwarebot@meysam.io"
  }]

  actions = [{
    type  = "forward"
    value = ["meysam@licenseware.io"]
  }]
}

resource "cloudflare_dns_record" "root_a" {
  for_each = toset([
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ])

  zone_id = data.cloudflare_zone.this.zone_id

  name    = "meysam.io"
  proxied = false
  ttl     = 3600
  type    = "A"
  content = each.value
}

resource "cloudflare_dns_record" "root_aaaa" {
  for_each = toset([
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153",
  ])

  zone_id = data.cloudflare_zone.this.zone_id

  name    = "meysam.io"
  proxied = false
  ttl     = 3600
  type    = "AAAA"
  content = each.value
}

resource "cloudflare_dns_record" "www" {
  zone_id = data.cloudflare_zone.this.zone_id

  name    = "www"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  content = "meysam.io"
}

resource "cloudflare_dns_record" "meysam_io_txt" {
  zone_id = data.cloudflare_zone.this.zone_id

  name    = "meysam.io"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
}

resource "cloudflare_dns_record" "wildcard_ipv4" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = data.hcloud_primary_ip.ipv4.ip_address
  name    = "*"
  proxied = true
  ttl     = 1
  type    = "A"
}

resource "cloudflare_dns_record" "wildcard_ipv6" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = data.hcloud_primary_ip.ipv6.ip_address
  name    = "*"
  proxied = true
  ttl     = 1
  type    = "AAAA"
}

resource "cloudflare_dns_record" "mail_spf" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = "\"v=spf1 include:_spf.maileroo.com ~all\""
  name    = "mail"
  ttl     = 1
  type    = "TXT"
}

resource "cloudflare_dns_record" "mail_dkim" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = "\"v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzve74oYhjhxGCofoj6j/7bJVJvFT0kCc9E+UYzFxQqxsrubUCc5UnUFF/v8fMHvfD1gnjthsI0XdPbe72dt0B8I90lWO064Y2mRzk5slzuIIDLwB/GbNTh4gW5//T+cQxyZlKtVvT4Hw5cEMRuP1YuPfxr8k0V9OYUhwnzxhZMS0FyzdZpA+aEjV1LiBwAhxjnJKb/1l/1OH608lyPdYWJ5MOC55nk1WtTRmkxpde50uQWMw9CXdMQYOmouwj1GZuRhKRngJmCOLOr4q//2BRiAtiE9Gi+ZrsQAZwlbj65IshJAdiVV780UsPccRC3hlSB9qb7ft7cPaaUmQBfixtQIDAQAB\""
  name    = "mta._domainkey.mail"
  ttl     = 1
  type    = "TXT"
}

resource "cloudflare_dns_record" "mail_dmarc" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = "\"v=DMARC1; p=reject;\""
  name    = "_dmarc.mail"
  ttl     = 1
  type    = "TXT"
}

resource "cloudflare_dns_record" "github_pages_challenge" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = "\"3200e1b2cfe928e2f6053846b28e86\""
  name    = "_github-pages-challenge-meysam81"
  ttl     = 1
  type    = "TXT"
}

resource "cloudflare_dns_record" "caa_letsencrypt" {
  zone_id = data.cloudflare_zone.this.zone_id

  name    = "@"
  proxied = false
  ttl     = 1
  type    = "CAA"

  data = {
    flags = 0
    tag   = "issuewild"
    value = "letsencrypt.org"
  }

}
