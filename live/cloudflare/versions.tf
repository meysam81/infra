terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "< 6"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "< 6"
    }
  }
  required_version = "< 2"
}
