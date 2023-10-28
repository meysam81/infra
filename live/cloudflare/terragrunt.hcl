include {
  path = find_in_parent_folders()
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_providers {
        cloudflare = {
          source = "cloudflare/cloudflare"
          version = "~> 4.14"
        }
      }
    }
    
    provider "cloudflare" {
      api_token = var.cloudflare_api_token
    }
  EOF
}
