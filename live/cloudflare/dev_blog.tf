data "cloudflare_zone" "dev_blog" {
  name = "developer-friendly.blog"
}

resource "cloudflare_record" "a_record" {
  for_each = toset([
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ])

  zone_id = data.cloudflare_zone.dev_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 300
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

  zone_id = data.cloudflare_zone.dev_blog.id

  name    = "developer-friendly.blog"
  proxied = false
  ttl     = 300
  type    = "AAAA"
  value   = each.key
}
