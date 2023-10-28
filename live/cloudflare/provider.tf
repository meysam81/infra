data "aws_ssm_parameter" "cloudflare_api_token" {
  count = var.cloudflare_api_token != "" ? 0 : 1
  name  = "/cloudflare/api_token"
}

variable "aws_profile" {
  type    = string
  default = "personal"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

locals {
  cloudflare_api_token = var.cloudflare_api_token != "" ? var.cloudflare_api_token : data.aws_ssm_parameter.cloudflare_api_token[0].value
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.14"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
