terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "< 6"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "< 2"
    }
  }
  required_version = "< 2"
}
