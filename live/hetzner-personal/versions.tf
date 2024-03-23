terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41"
    }
  }

  required_version = "<2"

}
