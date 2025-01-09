locals {
  tfc_hostname     = "app.terraform.io"
  tfc_organization = "meysam"
  workspace        = reverse(split("/", get_terragrunt_dir()))[0]
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      backend "remote" {
        hostname     = "${local.tfc_hostname}"
        organization = "${local.tfc_organization}"
        workspaces {
          name = "${local.workspace}"
        }
      }
    }
  EOF
}
