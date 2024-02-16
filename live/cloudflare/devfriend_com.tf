data "cloudflare_zone" "devfriend_com" {
  name = "developer-friendly.com"
}

resource "cloudflare_record" "devfriend_com_mailserver" {
  for_each = {
    "route1.mx.cloudflare.net" = 79,
    "route2.mx.cloudflare.net" = 87,
    "route3.mx.cloudflare.net" = 59,
  }

  zone_id = data.cloudflare_zone.devfriend_com.id

  name     = "developer-friendly.com"
  priority = each.value
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = each.key
}

resource "cloudflare_record" "devfriend_com_txt" {
  zone_id = data.cloudflare_zone.devfriend_com.id

  name    = "developer-friendly.com"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
}

resource "cloudflare_record" "devfriend_com_dmarc" {
  zone_id = data.cloudflare_zone.devfriend_com.id

  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=DMARC1; p=none; rua=mailto:7791bc4d4a21451faf803795caac660e@dmarc-reports.cloudflare.net;"
}

resource "cloudflare_record" "devfriend_com_substack" {
  zone_id = data.cloudflare_zone.devfriend_com.id

  name    = "@"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "target.substack-custom-domains.com"
}

resource "cloudflare_record" "devfriend_com_google_site_verification" {
  zone_id = data.cloudflare_zone.devfriend_com.id

  name    = "hyagyfbqrigp"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "gv-b6lgjkduelyu3e.dv.googlehosted.com"
}

resource "cloudflare_record" "devfriend_com_github_challenge" {
  zone_id = data.cloudflare_zone.devfriend_com.id

  name    = "_github-challenge-developer-friendly-org"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "ebb1b887a0"
}
