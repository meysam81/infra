generate "provider_cloudflare" {
  path      = "provider_cloudflare.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    variable "cloudflare_api_token" {
      type      = string
      nullable  = false
      sensitive = true
    }

    provider "cloudflare" {
      api_token = var.cloudflare_api_token
    }
  EOF
}
