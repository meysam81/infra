generate "provider_hetzner" {
  path      = "provider_hetzner.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    variable "hetzner_api_token" {
      type      = string
      nullable  = false
      sensitive = true
    }

    provider "hcloud" {
      token = var.hetzner_api_token
    }
  EOF
}
