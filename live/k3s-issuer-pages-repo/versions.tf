terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "< 7"
    }
    random = {
      source  = "hashicorp/random"
      version = "< 5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "< 5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "< 7"
    }
  }

  required_version = "< 2"
}

provider "github" {
  owner = var.github_owner
}
