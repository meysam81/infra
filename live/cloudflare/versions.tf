terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "< 5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "< 7"
    }
  }
  required_version = "< 2"
}
