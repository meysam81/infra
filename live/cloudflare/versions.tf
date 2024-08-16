terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.39"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.36"
    }
  }
}
