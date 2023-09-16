terraform {
  required_version = "~> 1.5"

  cloud {
    organization = "meysam"

    workspaces {
      name = "meysam-io"
    }
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.14"
    }
  }
}
