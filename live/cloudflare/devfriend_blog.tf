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

resource "cloudflare_record" "dev_blog_convertkit" {
  for_each = toset([
    "3.13.222.255",
    "3.13.246.91",
    "3.130.60.26",
  ])

  zone_id = data.cloudflare_zone.dev_blog.id

  name    = "mailing.developer-friendly.blog"
  proxied = false
  ttl     = 300
  type    = "A"
  value   = each.key
}

resource "cloudflare_record" "dev_blog_convertkit_delivery" {
  for_each = [
    {
      name = "ckespa",
      key  = "spf.dm-0m76g26y.sg6.convertkit.com.",
      type = "CNAME",
    },
    {
      name = "cka._domainkey",
      key  = "dkim.dm-0m76g26y.sg6.convertkit.com.",
      type = "CNAME",
    },
    {
      name = "_dmarc",
      key  = "v=DMARC1; p=none;",
      type = "TXT",
    },
  ]

  zone_id = data.cloudflare_zone.dev_blog.id

  name    = each.value.name
  proxied = false
  ttl     = 300
  type    = each.value.type
  value   = each.value.key
}
