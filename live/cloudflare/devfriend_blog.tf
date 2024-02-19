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

resource "cloudflare_record" "devfriend_blog_txt" {
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
  proxied = false
  ttl     = 3600
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
  proxied = false
  ttl     = 3600
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
  ttl     = 3600
  type    = "CNAME"
  value   = "developer-friendly.blog"
}
