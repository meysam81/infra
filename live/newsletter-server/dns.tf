data "cloudflare_zone" "this" {
  name = "developer-friendly.blog"
}

resource "cloudflare_record" "newsletter" {
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

resource "cloudflare_record" "alertmanager" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "alertmanager"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}

resource "cloudflare_record" "auth_server" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "auth-server"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}

resource "cloudflare_record" "auth" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "auth"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}

resource "cloudflare_record" "vmsingle" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "vmsingle"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}

resource "cloudflare_record" "vmagent" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "vmagent"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}

resource "cloudflare_record" "atlantis" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "atlantis"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}

resource "cloudflare_record" "hubble" {
  for_each = {
    A    = hcloud_primary_ip.this["ipv4"].ip_address
    AAAA = hcloud_primary_ip.this["ipv6"].ip_address
  }

  zone_id = data.cloudflare_zone.this.id

  name    = "hubble"
  proxied = true
  ttl     = 1
  type    = each.key
  content = each.value
}
