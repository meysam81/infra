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
  content = "smtp.google.com"
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

resource "cloudflare_record" "devfriend_blog_m1_spf" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "m1"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content   = "v=spf1 include:_spf.maileroo.com ~all"
}

resource "cloudflare_record" "devfriend_blog_m1_dkim" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "mta._domainkey.m1"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content   = "v=DKIM1;h=sha256;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtVB4nTmD4nq3FjPBMvCXIJFjCz5o0LMO9swtTbh4/9cxibEL8PwPw87pknTzMI3Kl6JLBNk9KBwvFKqkP6GuIRYFxF5KZrcm6TpyIGl0yLQradwGs8h+RoxDlu9k4qYF/PEIHFgl09wg4C0NYzXhCuzNC/VHEFb31YqzFqWKZn1hDhh7zD5uY53RkAXrE4GpazeQd4L50ZDZypGhssdl9ajd3mxibobp8DKg47M/IGvnTDdX+a8pEPl8Acr0KpCh3l5cw7SjzEvzFPYcf9H1VbzILP6DrGrDj41I5A1pc1AbKnhbcuUjLTW3czCh0QUlzLROe0VIGs6g4FG/CdaUKQIDAQAB"
}

resource "cloudflare_record" "devfriend_blog_m1_mx" {
  for_each = {
    "mx1.maileroo.com" = 10
    "mx2.maileroo.com" = 20
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id


  name     = "m1"
  proxied  = false
  ttl      = 1
  type     = "MX"
  priority = each.value
  content    = each.key
}

resource "cloudflare_record" "devfriend_blog_m1_dmarc" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "_dmarc.m1"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content   = "v=DMARC1; p=reject;"
}
