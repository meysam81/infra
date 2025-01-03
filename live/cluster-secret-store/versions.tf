

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "< 3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "< 6"
    }
  }

  required_version = "< 2"
}
