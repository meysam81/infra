terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source                = "integrations/github"
      version               = "6.0.0-rc2"
      configuration_aliases = [github.individual]
    }

    gpg = {
      source  = "Olivr/gpg"
      version = "~> 0.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }
}
