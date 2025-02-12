data "cloudflare_zone" "this" {
  zone_id = "8fd8676956b357c88a1082d8dc91fb6f"
}

data "hcloud_primary_ip" "ipv4" {
  name = "personal-ipv4"
}

data "hcloud_primary_ip" "ipv6" {
  name = "personal-ipv6"
}

resource "cloudflare_dns_record" "wildcard_ipv4" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = data.hcloud_primary_ip.ipv4.ip_address
  name    = "*"
  proxied = true
  ttl     = 1
  type    = "A"
}

resource "cloudflare_dns_record" "wildcard_ipv6" {
  zone_id = data.cloudflare_zone.this.zone_id
  content = data.hcloud_primary_ip.ipv6.ip_address
  name    = "*"
  proxied = true
  ttl     = 1
  type    = "AAAA"
}
