data "cloudflare_zone" "this" {
  zone_id = "8fd8676956b357c88a1082d8dc91fb6f"
}

data "hcloud_primary_ip" "ipv4" {
  name = "personal-ipv4"
}

data "hcloud_primary_ip" "ipv6" {
  name = "personal-ipv6"
}

data "cloudflare_accounts" "meysam" {
  name = "Meysam"
}
