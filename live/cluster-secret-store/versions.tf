

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41"
    }
  }

  required_version = "< 2"
}
