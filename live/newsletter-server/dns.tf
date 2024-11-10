data "cloudflare_zone" "this" {
  name = "developer-friendly.blog"
}

resource "cloudflare_record" "wildcard" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "*"
  proxied = false
  ttl     = 60
  type    = each.key
  content = each.value
}
