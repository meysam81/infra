terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "< 7"
    }
    random = {
      source  = "hashicorp/random"
      version = "< 4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "< 7"
    }
  }

  required_version = "< 2"
}
