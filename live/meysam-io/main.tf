data "cloudflare_zone" "this" {
  zone_id = "8fd8676956b357c88a1082d8dc91fb6f"
}

data "hcloud_primary_ip" "ipv4" {
  name = "personal-ipv4"
}

data "hcloud_primary_ip" "ipv6" {
  name = "personal-ipv6"
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
