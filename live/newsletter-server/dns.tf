data "cloudflare_zone" "this" {
  name = "developer-friendly.blog"
}

resource "cloudflare_record" "this" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "newsletter"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}
