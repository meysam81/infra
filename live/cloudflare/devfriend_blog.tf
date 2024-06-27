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
    "35.185.44.232",
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
  value   = "developer-friendly.github.io"
}

resource "cloudflare_record" "github_domain_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_github-challenge-developer-friendly-org"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "06e0a79c66"
}

resource "cloudflare_record" "devfriend_blog_mandrillapp_txt" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "mandrill_verify.HpAYL5AwBEAKayRaLLfEtg"
}

resource "cloudflare_record" "devfriend_blog_maileroo_txt" {
  for_each = {
    "@"              = "v=spf1 include:_spf.maileroo.com ~all",
    "mta._domainkey" = "v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA00B04bAF2E7b1XLYpno/AgcOX27W2imOZ8UvqfQ2K3k057hCb5ISyb2C7AXaicz7JtXupU/D8hGWQH1rqADWLER44PWw87cbp8NKnwWwBy74jNWaS4+d+U8+IODQpeH6jfMlJLridbnr0sR6WEd58LKWsV4U3nBG0q0ULBhWhrmNfRMOnvPvMD5CeqHM/s2SINEDSfG4Nlbll8bEPyuR9Ebug4MJRLU/5EFfTNmvADcEdggDjSHY4RE9EDVoGdKYK1kSpCGT1YtTyBMgHyewZ5H3nbgHE0e1BfWaBDSp5WI8iMGu/nyuMC/TggM07oITdKpsZJH7W2Fw/80PA93EjwIDAQAB",
    "_dmarc"         = "v=DMARC1; p=reject;",
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = each.key
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = each.value
}

resource "cloudflare_record" "devfriend_blog_maileroo_cname" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "click"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "click.maileroo.net"
}

resource "cloudflare_record" "ory" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "ory"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "developer-friendly.github.io"
}

resource "cloudflare_ruleset" "ory" {
  zone_id = data.cloudflare_zone.devfriend_blog.id
  name    = "Set CORS header"
  kind    = "zone"
  phase   = "http_response_headers_transform"

  rules {
    action = "rewrite"
    action_parameters {
      dynamic "headers" {
        for_each = {
          "access-control-allow-credentials" : "true"
          "access-control-allow-headers" : "*"
          "access-control-allow-methods" : "GET, PUT, POST, DELETE, OPTIONS"
          "access-control-expose-headers" : "Content-Type, Origin"
        }

        content {
          name      = headers.key
          operation = "set"
          value     = headers.value
        }
      }
    }

    expression  = "(http.host eq \"ory.developer-friendly.blog\")"
    description = "Set CORS headers for ORY"
    enabled     = true
  }
}

resource "cloudflare_record" "sendgrid_cname" {
  for_each = {
    "em8552"        = "u42195761.wl012.sendgrid.net",
    "s1._domainkey" = "s1.domainkey.u42195761.wl012.sendgrid.net",
    "s2._domainkey" = "s2.domainkey.u42195761.wl012.sendgrid.net",
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = each.key
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = each.value
}

resource "cloudflare_record" "emailoctopus" {
  for_each = {
    "eo._domainkey" = "eo._domainkey.4bf5dc1bf4.alecto.eoidentity.com",
    "eom"           = "eom.4bf5dc1bf4.alecto.eoidentity.com",
    "eot"           = "eot.4bf5dc1bf4.alecto.eoidentity.com",
    "45165608"      = "45165608.4bf5dc1bf4.alecto.eoidentity.com",
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = each.key
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = each.value
}

resource "cloudflare_record" "convertkit" {
  for_each = {
    "ckespa"         = "spf.dm-0m76g26y.sg6.convertkit.com."
    "cka._domainkey" = "dkim.dm-0m76g26y.sg6.convertkit.com."
    # "_dmarc"         = "v=DMARC1; p=none;"
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = each.key
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = each.value
}

resource "cloudflare_record" "convertkit_mailing" {
  for_each = toset([
    "3.13.222.255",
    "3.13.246.91",
    "3.130.60.26",
  ])

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "mailing"
  proxied = true
  ttl     = 1
  type    = "A"
  value   = each.key
}

resource "cloudflare_record" "gitlab_pages_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_gitlab-pages-verification-code"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "gitlab-pages-verification-code=de0a984291ce9bc428e911f114321a42"
}
