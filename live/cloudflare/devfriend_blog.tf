data "cloudflare_zone" "devfriend_blog" {
  name = "developer-friendly.blog"
}

resource "cloudflare_record" "devfriend_blog_mx" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name     = "@"
  proxied  = false
  ttl      = 1
  type     = "MX"
  priority = 1
  value    = "smtp.google.com"
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

resource "cloudflare_record" "devfriend_blog_www" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "www"
  proxied = false
  ttl     = 60
  type    = "CNAME"
  value   = "developer-friendly.github.io"
}

resource "cloudflare_record" "devfriend_blog_google_site_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "google-site-verification=15rKHEVUtnjs_0SZ64rH-ezk64KgrK7C5ty9W60NSwE"
}

resource "cloudflare_record" "github_domain_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_github-challenge-developer-friendly-org"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "06e0a79c66"
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

resource "cloudflare_record" "emailoctopus" {
  for_each = {
    "eo._domainkey" = "eo._domainkey.45cb31060b.arborescens.eoidentity.com",
    "eom"           = "eom.45cb31060b.arborescens.eoidentity.com",
    "eot"           = "eot.45cb31060b.arborescens.eoidentity.com",
    "45165608"      = "45165608.45cb31060b.arborescens.eoidentity.com",
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "${each.key}.mailing"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = each.value
}

resource "cloudflare_record" "dmarc" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_dmarc.mailing"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=DMARC1; p=none;"
}

resource "cloudflare_record" "gitlab_pages_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_gitlab-pages-verification-code"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "gitlab-pages-verification-code=de0a984291ce9bc428e911f114321a42"
}

resource "cloudflare_record" "google_workspace_verification" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "@"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "google-site-verification=ldeIYvypI-BWURXxAIDTPkp8WIB51jhZ1THJS0lPIrE"
}
