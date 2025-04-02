data "cloudflare_zone" "devfriend_blog" {
  name = "developer-friendly.blog"
}

resource "cloudflare_record" "protonmail_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "@"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"protonmail-verification=1cdf57560b280ac8fc27f6c1d7200f37b6f00910\""
}

resource "cloudflare_record" "mail_protonmail_ch" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name     = "@"
  proxied  = false
  ttl      = 1
  type     = "MX"
  priority = 10
  content  = "mail.protonmail.ch"
}

resource "cloudflare_record" "mailsec_protonmail_ch" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name     = "@"
  proxied  = false
  ttl      = 1
  type     = "MX"
  priority = 20
  content  = "mailsec.protonmail.ch"
}

resource "cloudflare_record" "a_record" {
  for_each = toset([
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
    # "35.185.44.232",
  ])

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 60
  type    = "A"
  content = each.key
}

resource "cloudflare_record" "aaaa_record" {
  for_each = toset([
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153",
  ])

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 60
  type    = "AAAA"
  content = each.key
}

resource "cloudflare_record" "devfriend_blog_www" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "www"
  proxied = false
  ttl     = 60
  type    = "CNAME"
  content = "developer-friendly.github.io"
}

resource "cloudflare_record" "devfriend_blog_google_site_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "google-site-verification=15rKHEVUtnjs_0SZ64rH-ezk64KgrK7C5ty9W60NSwE"
}

resource "cloudflare_record" "github_domain_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_github-challenge-developer-friendly-org"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  content = "06e0a79c66"
}

resource "cloudflare_record" "gitlab_pages_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_gitlab-pages-verification-code"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "gitlab-pages-verification-code=de0a984291ce9bc428e911f114321a42"
}

resource "cloudflare_record" "google_workspace_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "@"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "google-site-verification=ldeIYvypI-BWURXxAIDTPkp8WIB51jhZ1THJS0lPIrE"
}

resource "cloudflare_record" "devfriend_blog_mailing_spf" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "mailing"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:_spf.maileroo.com include:_spf.mx.cloudflare.net ~all\""
}

resource "cloudflare_record" "devfriend_blog_mailing_dkim" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "mta._domainkey.mailing"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxbNNobCcMNriIcS2r5CkdaZ0eMds9tEhtV3pkaWhuX/xIW3rY49auqfe6HEp9JBiYX57w2xSlSf/kJTcb+t2aayQSz1G3jXwXpI5PoU64KkPfJ5YSnNm/xn3yqxVet6sTXpkRgGP6qQ7n/IxQZop92izfO4dfdDcKJxNZwNBYuBJsCMe+Sd+kutYioh1wR0Ybwa/3coF9onqVkc71grneUroNXuNBhMJTiWgMnYtytKp7EGWh3MUu3SDgDYmqDlGimvRGfYI4vvfoXFfq/LsFOF6BKTZNyG4Wh05lVyKT+rtP14OlQVyuRBAKWpQOO55vV2ZmG4H49hQm7shFx3fHQIDAQAB"
}

resource "cloudflare_record" "devfriend_blog_mailing_mx" {
  for_each = {
    "route1.mx.cloudflare.net" = 28,
    "route2.mx.cloudflare.net" = 31,
    "route3.mx.cloudflare.net" = 9,
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id


  name     = "mailing"
  proxied  = false
  ttl      = 1
  type     = "MX"
  priority = each.value
  content  = each.key
}

resource "cloudflare_record" "devfriend_blog_mailing_dmarc" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_dmarc.mailing"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "v=DMARC1; p=reject;"
}

resource "cloudflare_record" "click_mailing" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "click.mailing"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "click.maileroo.net"
}

resource "cloudflare_record" "dmarc_email" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_dmarc.email"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "v=DMARC1; p=none;"
}

resource "cloudflare_record" "caa" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "@"
  proxied = false
  ttl     = 1
  type    = "CAA"

  data {
    flags = 0
    tag   = "issuewild"
    value = "letsencrypt.org"
  }
}
