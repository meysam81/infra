terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "< 4"
    }
  }
  required_version = "< 2"
}

provider "github" {
  owner = "meysam81"
}
