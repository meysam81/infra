data "cloudflare_zone" "devfriend_blog" {
  name = "developer-friendly.blog"
}

resource "cloudflare_record" "devfriend_blog_mailserver" {
  for_each = {
    "route1.mx.cloudflare.net" = 28,
    "route2.mx.cloudflare.net" = 31,
    "route3.mx.cloudflare.net" = 9,
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name     = "developer-friendly.blog"
  priority = each.value
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = each.key
}

resource "cloudflare_record" "devfriend_blog_cloudflare" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
}

resource "cloudflare_email_routing_catch_all" "devfriend_blog_email_catch_all" {
  zone_id = data.cloudflare_zone.devfriend_blog.id
  name    = "catch all"
  enabled = true

  matcher {
    type = "all"
  }

  action {
    type  = "forward"
    value = [var.target_email_address]
  }
}

resource "cloudflare_record" "a_record" {
  for_each = toset([
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ])

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = true
  ttl     = 1
  type    = "A"
  value   = each.key
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
  proxied = true
  ttl     = 1
  type    = "AAAA"
  value   = each.key
}

resource "cloudflare_record" "devfriend_blog_google_site_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "google-site-verification=15rKHEVUtnjs_0SZ64rH-ezk64KgrK7C5ty9W60NSwE"
}

resource "cloudflare_record" "devfriend_blog_www" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "developer-friendly.blog"
}

resource "cloudflare_record" "github_domain_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_github-challenge-developer-friendly-org"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "06e0a79c66"
}

resource "cloudflare_record" "devfriend_blog_mandrillapp" {
  for_each = {
    "mte1._domainkey" = "dkim1.mandrillapp.com",
    "mte2._domainkey" = "dkim2.mandrillapp.com",
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = each.key
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = each.value
}

resource "cloudflare_record" "devfriend_blog_mandrillapp_txt" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "mandrill_verify.HpAYL5AwBEAKayRaLLfEtg"
}

# TXT newsletter.developer-friendly.blog v=spf1 include:_spf.maileroo.com ~all
# TXT mta._domainkey.newsletter.developer-friendly.blog v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtwoLlnNHF5QSKVIbZ6PJ0zcF0IyxELjBgoqWz/fl1/jcHnk9hFiaSNz1yMnQaONQQmhUoOVZUWzMEq/EJmCdBa3M8uv+fwECMAktcOCTw91hOPMNGlAFLRbpjJvDvabM9lprM9zmtvnp4MnxPAGB7nhjQRxzyMihLindvp9otclrxwSW949HGsbm1Vtx8lN94N1yxi/L5w0KKn5OXM955OsGsxy4N6YSpF4O6ZFiAR4thHek1I65cwG9AN9UHyjR2PGEvRVjZFDalUcBiXMxJK/URYcriPXLoW9o8DuhIFgKZIMjfF8l0oxeka/aRREuDCKBfNVjJQ3CU31vLNbscwIDAQAB
# MX newsletter.developer-friendly.blog mx1.maileroo.com priority 10
# MX newsletter.developer-friendly.blog mx2.maileroo.com priority 20
# TXT _dmarc.newsletter.developer-friendly.blog v=DMARC1; p=reject;
# CNAME click.newsletter.developer-friendly.blog click.maileroo.com
resource "cloudflare_record" "devfriend_blog_maileroo_txt" {
  for_each = {
    "newsletter"                = "v=spf1 include:_spf.maileroo.com ~all",
    "mta._domainkey.newsletter" = "v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtwoLlnNHF5QSKVIbZ6PJ0zcF0IyxELjBgoqWz/fl1/jcHnk9hFiaSNz1yMnQaONQQmhUoOVZUWzMEq/EJmCdBa3M8uv+fwECMAktcOCTw91hOPMNGlAFLRbpjJvDvabM9lprM9zmtvnp4MnxPAGB7nhjQRxzyMihLindvp9otclrxwSW949HGsbm1Vtx8lN94N1yxi/L5w0KKn5OXM955OsGsxy4N6YSpF4O6ZFiAR4thHek1I65cwG9AN9UHyjR2PGEvRVjZFDalUcBiXMxJK/URYcriPXLoW9o8DuhIFgKZIMjfF8l0oxeka/aRREuDCKBfNVjJQ3CU31vLNbscwIDAQAB",
    "_dmarc.newsletter"         = "v=DMARC1; p=reject;",
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = each.key
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = each.value
}

resource "cloudflare_record" "devfriend_blog_maileroo_mx" {
  for_each = {
    "mx1" = ["mx1.maileroo.com", 10],
    "mx2" = ["mx2.maileroo.com", 20],
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name     = "newsletter"
  priority = each.value[1]
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = each.value[0]
}

resource "cloudflare_record" "devfriend_blog_maileroo_cname" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "click.newsletter"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "click.maileroo.net"
}
