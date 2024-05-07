data "cloudflare_zone" "devfriend_blog" {
  name = "developer-friendly.blog"
}

resource "random_uuid" "this" {}

resource "cloudflare_record" "this" {
  for_each = {
    "A"    = "ipv4"
    "AAAA" = "ipv6"
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = format("%s.developer-friendly.blog", random_uuid.this.id)
  proxied = false
  ttl     = 60
  type    = each.key
  value   = hcloud_primary_ip.this[each.value].ip_address
}

resource "cloudflare_record" "newsletter" {
  for_each = {
    "A"    = "ipv4"
    "AAAA" = "ipv6"
  }

  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = "newsletter.developer-friendly.blog"
  proxied = false
  ttl     = 60
  type    = each.key
  value   = hcloud_primary_ip.this[each.value].ip_address
}