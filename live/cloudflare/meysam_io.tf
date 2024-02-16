data "cloudflare_zone" "meysam_io" {
  name = "meysam.io"
}

resource "cloudflare_record" "medium" {
  for_each = toset([
    "162.159.152.4",
    "162.159.153.4",
  ])

  zone_id = data.cloudflare_zone.meysam_io.id

  name    = "meysam.io"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = each.value
}

resource "cloudflare_record" "medium_www" {
  for_each = toset([
    "162.159.152.4",
    "162.159.153.4",
  ])

  zone_id = data.cloudflare_zone.meysam_io.id

  name    = "www"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = each.key
}

resource "cloudflare_record" "meysam_mailserver" {
  for_each = {
    "route1.mx.cloudflare.net" = 76,
    "route2.mx.cloudflare.net" = 50,
    "route3.mx.cloudflare.net" = 47,
  }

  zone_id = data.cloudflare_zone.meysam_io.id

  name     = "meysam.io"
  priority = each.value
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = each.key
}

resource "cloudflare_record" "meysam_io_txt" {
  zone_id = data.cloudflare_zone.meysam_io.id

  name    = "meysam.io"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:_spf.mx.cloudflare.net ~all"
}

resource "cloudflare_record" "hashnode" {
  zone_id = data.cloudflare_zone.meysam_io.id

  name    = "h"
  proxied = false
  ttl     = 60
  type    = "CNAME"
  value   = "hashnode.network"
}
