variable "aws_profile" {
  type    = string
  default = "personal"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
