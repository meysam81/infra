generate "provider_aws" {
  path      = "provider_aws.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      profile = "personal"
      region  = "ap-southeast-1"
    }
  EOF
}
